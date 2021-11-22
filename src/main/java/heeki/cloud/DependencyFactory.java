
package heeki.cloud;

import software.amazon.awssdk.auth.credentials.EnvironmentVariableCredentialsProvider;
import software.amazon.awssdk.http.urlconnection.UrlConnectionHttpClient;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.lambda.LambdaClient;

public class DependencyFactory {
    private DependencyFactory() {}

    public static LambdaClient lambdaClient() {
        return LambdaClient.builder()
            .credentialsProvider(EnvironmentVariableCredentialsProvider.create())
            .region(Region.US_EAST_2)
            .httpClientBuilder(UrlConnectionHttpClient.builder())
            .build();
    }
}
