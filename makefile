include etc/environment.sh

lambda: lambda.package lambda.deploy
lambda.package:
	sam package -t ${LAMBDA_TEMPLATE} --region ${REGION} --output-template-file ${LAMBDA_OUTPUT} --s3-bucket ${S3BUCKET}
lambda.deploy:
	sam deploy -t ${LAMBDA_OUTPUT} --region ${REGION} --stack-name ${LAMBDA_STACK} --parameter-overrides ${LAMBDA_PARAMS} --capabilities CAPABILITY_NAMED_IAM

lambda.local:
	sam local invoke -t ${LAMBDA_TEMPLATE} --parameter-overrides ${LAMBDA_PARAMS} --env-vars etc/envvars.json -e etc/event.json Fn | jq
lambda.invoke.sync:
	aws --profile ${PROFILE} lambda invoke --region ${REGION} --function-name ${O_FN} --invocation-type RequestResponse --payload file://etc/event.json --cli-binary-format raw-in-base64-out --log-type Tail tmp/fn.json | jq "." > tmp/response.json
	cat tmp/response.json | jq -r ".LogResult" | base64 --decode
	cat tmp/fn.json | jq
lambda.invoke.async:
	aws --profile ${PROFILE} lambda invoke --region ${REGION} --function-name ${O_FN} --invocation-type Event --payload file://etc/event.json --cli-binary-format raw-in-base64-out --log-type Tail tmp/fn.json | jq "."

mvn: mvn.package mvn.exec
mvn.package:
	mvn clean package
mvn.exec:
	rm -f tmp/${P_S3_FILE}
	mvn exec:java

release: mvn.package spotbugs
spotbugs:
	java -jar ${SPOTBUGS_HOME}/lib/spotbugs.jar -textui ${P_TARGET_JAR} | tee target/spotsbugs.txt
pmd.json:
	${PMD_HOME}/bin/run.sh pmd -d ${P_SOURCE_DIR} -R rulesets/java/quickstart.xml -f json | tee target/pmd.json | jq
pmd.text:
	${PMD_HOME}/bin/run.sh pmd -d ${P_SOURCE_DIR} -R rulesets/java/quickstart.xml -f text | tee target/pmd.txt