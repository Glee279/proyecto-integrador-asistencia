package com.integration.final_proyect.models;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "asistencia")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Asistencia {

    @Id
    @Column(name = "id_asistencia")
    private Long idAsistencia;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_usuario", nullable = false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_sede")
    private Sede sede;

    @Column(name = "fec_entrada", nullable = false)
    private LocalDateTime fecEntrada;

    @Column(name = "fec_salida")
    private LocalDateTime fecSalida;

    @Column(name = "mca_estado", length = 2)
    private String mcaEstado;  // RI / RC

    @Column(name = "tip_asistencia", length = 10, nullable = false)
    private String tipAsistencia; // MANUAL / QR

    @Column(name = "mca_baja", length = 1)
    private String mcaBaja; // N / S

}
