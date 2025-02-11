package epam.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Info {
    private String description;
    private String version;
    private String title;
    private String termsOfService;
    private Contact contact;
    private License license;
}