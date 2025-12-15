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
@Table(name = "qr_token")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class QrToken {

    @Id
    @Column(name = "id_qr")
    private Long idQr;

    @Column(name = "codigo_qr", length = 500, nullable = false)
    private String codigoQr;

    @Column(name = "fec_generado", nullable = false)
    private LocalDateTime fecGenerado;

    @Column(name = "fec_expira", nullable = false)
    private LocalDateTime fecExpira;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_sede", nullable = false)
    private Sede sede;

    @Column(name = "mca_estado", length = 1, nullable = false)
    private String mcaEstado; // A / E

}
