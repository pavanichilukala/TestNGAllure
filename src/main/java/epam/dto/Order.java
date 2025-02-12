package epam.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Order {
    private Long id;
    private Long petId;
    private Integer quantity;
    private String shipDate;
    private String status; // Order Status
    private Boolean complete;
}
