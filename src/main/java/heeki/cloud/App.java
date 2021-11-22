package heeki.cloud;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import software.amazon.awssdk.services.lambda.LambdaClient;

public class App implements RequestHandler<Object, Object> {
    private final LambdaClient lambdaClient;
    private final Gson gson;

    public App() {
        lambdaClient = DependencyFactory.lambdaClient();
        gson = new GsonBuilder().create();
    }

    @Override
    public Object handleRequest(final Object event, final Context context) {
        LambdaLogger logger = context.getLogger();
        logger.log(gson.toJson(event));
        return event;
    }
}
