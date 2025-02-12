package epam.api;

import epam.dto.Pet;
import io.restassured.RestAssured;
import io.restassured.response.Response;

public class PetApi {
    
    private static final String BASE_URL = "https://petstore3.swagger.io/api/v3";
    
    public Response updatePet(Pet pet) {
        return RestAssured
                .given()
                .contentType("application/json")
                .body(pet)
                .when()
                .put(BASE_URL + "/pet")
                .then()
                .extract()
                .response();
    }
}
