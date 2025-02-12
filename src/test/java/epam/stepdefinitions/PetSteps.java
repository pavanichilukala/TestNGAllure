package epam.stepdefinitions;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.When;
import io.cucumber.java.en.Then;
import io.restassured.RestAssured;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import org.testng.Assert;

import java.util.Map;

public class PetSteps {

    private Response response;
    private RequestSpecification request;
    private String baseUrl = "https://petstore.swagger.io/v2/pet";

    @Given("I have a pet with ID {int}")
    public void i_have_a_pet_with_id(Integer id) {
        request = RestAssured.given();
        request.pathParam("petId", id);
    }

    @When("I update the pet with the following details")
    public void i_update_the_pet_with_the_following_details(Map<String, String> petDetails) {
        request.header("Content-Type", "application/json");
        request.body(petDetails);
        response = request.put(baseUrl + "/{petId}");
    }

    @Then("the pet should be updated successfully")
    public void the_pet_should_be_updated_successfully() {
        Assert.assertEquals(response.getStatusCode(), 200);
        Assert.assertEquals(response.jsonPath().getString("name"), "Doggie");
        Assert.assertEquals(response.jsonPath().getString("status"), "available");
    }

    @Then("I should receive an error message {string}")
    public void i_should_receive_an_error_message(String expectedMessage) {
        Assert.assertEquals(response.getStatusCode(), 404);
        Assert.assertEquals(response.jsonPath().getString("message"), expectedMessage);
    }
}
