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
@Table(name = "usuario")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Usuario {

    @Id
    @Column(name = "id_usuario")
    private Long idUsuario;

    @Column(name = "usuario", length = 50, nullable = false, unique = true)
    private String usuario;

    @Column(name = "pass_usu", length = 128, nullable = false)
    private String passUsu;

    @Column(name = "salt_usu", length = 32, nullable = false)
    private String saltUsu;

    @Column(name = "mca_estado", length = 1, nullable = false)
    private String mcaEstado;   // A/I

    @Column(name = "area", length = 50, nullable = false)
    private String area;

    @Column(name = "hora_ini", length = 5, nullable = false)
    private String horaIni;

    @Column(name = "hora_fin", length = 5, nullable = false)
    private String horaFin;

    @Column(name = "modalidad", length = 20, nullable = false)
    private String modalidad;   // PRESENCIAL/REMOTO

    @Column(name = "apel_pat", length = 20, nullable = false)
    private String apelPat;

    @Column(name = "apel_mat", length = 20, nullable = false)
    private String apelMat;

    @Column(name = "pri_nombre", length = 20, nullable = false)
    private String priNombre;

    @Column(name = "seg_nombre", length = 50)
    private String segNombre;

    @Column(name = "dni", length = 8, nullable = false, unique = true)
    private String dni;

    @Column(name = "telefono", length = 9, nullable = false)
    private String telefono;

    @Column(name = "direccion", length = 100, nullable = false)
    private String direccion;

    @Column(name = "correo_per", length = 100, nullable = false)
    private String correoPer;

    @Column(name = "correo_cor", length = 100, nullable = false, unique = true)
    private String correoCor;

}
