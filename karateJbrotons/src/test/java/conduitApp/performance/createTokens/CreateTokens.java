package conduitApp.performance.createTokens;

import com.intuit.karate.Runner;
import java.util.ArrayList;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;

public class CreateTokens {

    private static final ArrayList<String> tokens = new ArrayList<>();
    private static final AtomicInteger counter = new AtomicInteger();

    private static String[] emails ={
        "jbrotons1@outlook.com",
        "jbrotons2@outlook.com",
        "jbrotons3@outlook.com"
    };

    public static String getNextToken(){
        return tokens.get(counter.getAndIncrement() % tokens.size());
    }

    public static void createAccessTokens(){
        for(String email: emails){
            Map<String, Object> account = new HashMap<>();
            account.put("userEmail", email);
            account.put("userPassword", "Welcome1");
            Map<String, Object> result = Runner.runFeature("classpath:helpers/CreateToken.feature", account, true);
            tokens.add(result.get("authToken").toString());
        }
    }

}