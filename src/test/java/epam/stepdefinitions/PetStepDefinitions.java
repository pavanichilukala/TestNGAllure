package epam.stepdefinitions;

import epam.api.PetApi;
import epam.dto.Category;
import epam.dto.Pet;
import epam.dto.Tag;
io.cucumber.java.en.Given;
io.cucumber.java.en.Then;
io.cucumber.java.en.When;
io.restassured.response.Response;

import java.util.Arrays;
import java.util.List;

import static org.junit.Assert.assertEquals;

public class PetStepDefinitions {
    private Pet pet;
    private Response response;

    @Given("the PetStore API is available")
    public void the_PetStore_API_is_available() {
        // Assuming the API is always available for simplicity
    }

    @Given("a pet with ID {long} exists in the system")
    public void a_pet_with_ID_exists_in_the_system(Long petId) {
        // Fetch the pet details from the system and set it to the pet object
        // For simplicity, creating a dummy pet object
        pet = new Pet();
        pet.setId(petId);
        pet.setCategory(new Category(1L, "Dogs"));
        pet.setName("Rex");
        pet.setPhotoUrls(Arrays.asList("url1", "url2"));
        pet.setTags(Arrays.asList(new Tag(1L, "tag1")));
        pet.setStatus("available");
    }

    @When("User updates the pet with the following details:")
    public void user_updates_the_pet_with_the_following_details(io.cucumber.datatable.DataTable dataTable) {
        List<List<String>> data = dataTable.asLists(String.class);
        String name = data.get(1).get(0);
        String status = data.get(1).get(1);
        String category = data.get(1).get(2);
        List<String> tags = Arrays.asList(data.get(1).get(3).split(","));
        List<String> photoUrls = Arrays.asList(data.get(1).get(4).split(","));

        pet.setName(name);
        pet.setStatus(status);
        pet.setCategory(new Category(1L, category));
        pet.setTags(Arrays.asList(new Tag(1L, tags.get(0))));
        pet.setPhotoUrls(photoUrls);
    }

    @When("the user updates the pet")
    public void the_user_updates_the_pet() {
        PetApi petApi = new PetApi();
        response = petApi.updatePet(pet);
    }

    @Then("the pet details should be updated successfully")
    public void the_pet_details_should_be_updated_successfully() {
        assertEquals(200, response.getStatusCode());
        Pet updatedPet = response.getBody().as(Pet.class);
        assertEquals(pet.getId(), updatedPet.getId());
        assertEquals(pet.getName(), updatedPet.getName());
        assertEquals(pet.getCategory().getName(), updatedPet.getCategory().getName());
        assertEquals(pet.getPhotoUrls(), updatedPet.getPhotoUrls());
        assertEquals(pet.getTags().get(0).getName(), updatedPet.getTags().get(0).getName());
        assertEquals(pet.getStatus(), updatedPet.getStatus());
    }
}
