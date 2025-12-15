package com.integration.final_proyect.models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "sede")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Sede {

    @Id
    @Column(name = "id_sede")
    private Long idSede;

    @Column(name = "nombre", length = 100, nullable = false, unique = true)
    private String nombre;

    @Column(name = "direccion", length = 300, nullable = false)
    private String direccion;

    @Column(name = "mca_estado", length = 1, nullable = false)
    private String mcaEstado; // A/I

}
