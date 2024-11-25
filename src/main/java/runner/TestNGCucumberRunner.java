package runner;

import io.cucumber.testng.AbstractTestNGCucumberTests;
import io.cucumber.testng.CucumberOptions;

@CucumberOptions(
    features = "src/test/resources/features",
    glue = "com.example.stepdefinitions",
    plugin = {"pretty", "io.qameta.allure.cucumber5jvm.AllureCucumber5Jvm"}
)
public class TestNGCucumberRunner extends AbstractTestNGCucumberTests {
}
