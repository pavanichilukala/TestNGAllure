package epam.stepdefinitions;

import epam.dto.Pet;
import epam.dto.Category;
import epam.dto.Tag;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.When;
import io.cucumber.java.en.Then;
import static org.junit.Assert.*;
import java.util.Arrays;
import java.util.Map;

public class UpdatePetSteps {

    private Pet pet;

    @Given("a pet with ID {int} exists in the store")
    public void a_pet_with_id_exists_in_the_store(Integer id) {
        // Initialize the pet object with ID
        pet = new Pet();
        pet.setId(id.longValue());
        pet.setCategory(new Category(1L, "Dogs"));
        pet.setName("Buddy");
        pet.setPhotoUrls(Arrays.asList("url1", "url2"));
        pet.setTags(Arrays.asList(new Tag(1L, "tag1"), new Tag(2L, "tag2")));
        pet.setStatus("available");
    }

    @When("I update the pet with the following details")
    public void i_update_the_pet_with_the_following_details(Map<String, String> details) {
        // Update the pet details
        if(details.containsKey("name")) {
            pet.setName(details.get("name"));
        }
        if(details.containsKey("status")) {
            pet.setStatus(details.get("status"));
        }
        // Add more fields as needed
    }

    @Then("the pet details should be updated successfully")
    public void the_pet_details_should_be_updated_successfully() {
        // Validate the updated pet details
        assertNotNull(pet);
        assertEquals("Buddy", pet.getName());
        assertEquals("available", pet.getStatus());
        // Add more assertions as needed
    }
}
