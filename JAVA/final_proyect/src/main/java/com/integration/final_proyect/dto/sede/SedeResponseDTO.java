package com.integration.final_proyect.dto.sede;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Data
@Builder
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class SedeResponseDTO {

    private Long idSede;
    private String nombre;
    private String direccion;
    private String estado;

}
