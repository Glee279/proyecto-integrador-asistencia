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
@Table(name = "justificacion")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Justificacion {

    @Id
    @Column(name = "id_justificacion")
    private Long idJustificacion;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_usuario", nullable = false)
    private Usuario usuario;

    @Column(name = "titulo", length = 50, nullable = false)
    private String titulo;

    @Column(name = "descripcion", length = 1000, nullable = false)
    private String descripcion;

    @Column(name = "fec_evento", nullable = false)
    private LocalDateTime fecEvento;

    @Column(name = "fec_reg", nullable = false)
    private LocalDateTime fecReg;

    @Column(name = "tip_justificacion", length = 1, nullable = false)
    private String tipJustificacion; // T / A

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "revision")
    private Usuario usuarioRevision;

    @Column(name = "fec_revision")
    private LocalDateTime fecRevision;

    @Column(name = "comment_revision", length = 1000)
    private String commentRevision;

    @Column(name = "archivo_url", length = 500)
    private String archivoUrl;

    @Column(name = "mca_estado", length = 1)
    private String mcaEstado;      // P / A / R

    @Column(name = "mca_baja", length = 1)
    private String mcaBaja;        // N/S

}
