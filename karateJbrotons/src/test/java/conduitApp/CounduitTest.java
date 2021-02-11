package conduitApp;

import com.intuit.karate.junit5.Karate;
import com.intuit.karate.KarateOptions;
import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.io.File;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;

@KarateOptions( tags = {"@debug", "@regression"})
class CounduitTest {
    
    // this will run all *.feature files that exist in sub-directories
    // see https://github.com/intuit/karate#naming-conventions   
    //@Karate.Test
    //Karate testAll() {
    //    return Karate.run().relativeTo(getClass());
    //}

    @Test
    void testParallel() {
        Results results = Runner.parallel(getClass(), 5);
        generateReport(results.getReportDir());
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
    //@Karate.Test
    //Karate testTags() {
   //     return Karate.run().tags("@debug").relativeTo(getClass());
    //}
    
    
    //Cucumber reporting
    public static void generateReport(String karateOutputPath) {        
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] {"json"}, true);
        List<String> jsonPaths = new ArrayList(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("target"), "Conduit Application");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();        
    }

    
}
