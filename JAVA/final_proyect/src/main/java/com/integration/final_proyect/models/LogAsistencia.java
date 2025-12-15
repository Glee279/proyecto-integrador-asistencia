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
@Table(name = "log_asistencia")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LogAsistencia {

    @Id
    @Column(name = "id_log_asistencia")
    private Long idLogAsistencia;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_asistencia", nullable = false)
    private Asistencia asistencia;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_usuario", nullable = false)
    private Usuario usuario;

    @Column(name = "accion", length = 20, nullable = false)
    private String accion;

    @Column(name = "fec_accion", nullable = false)
    private LocalDateTime fecAccion;

}
