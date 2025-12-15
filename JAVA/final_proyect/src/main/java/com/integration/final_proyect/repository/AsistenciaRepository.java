package com.integration.final_proyect.repository;

import java.sql.Date;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.integration.final_proyect.dto.asistencia.AsistenciaHistorialResponseDTO;
import com.integration.final_proyect.models.Asistencia;

@Repository
public interface AsistenciaRepository extends JpaRepository<Asistencia, Long> {

  @Query("""
          SELECT a
          FROM Asistencia a
          WHERE a.usuario.idUsuario = :idUsuario
            AND a.fecSalida IS NULL
            AND a.mcaBaja = 'N'
      """)
  Optional<Asistencia> findAsistenciaAbierta(Long idUsuario);

  @Query("""
          SELECT new com.integration.final_proyect.dto.asistencia.AsistenciaHistorialResponseDTO(
              a.idAsistencia,
              a.fecEntrada,
              a.fecSalida,
              a.tipAsistencia,
              a.mcaEstado,
              s.nombre
          )
          FROM Asistencia a
          LEFT JOIN a.sede s
          WHERE a.usuario.idUsuario = :idUsuario
            AND a.mcaBaja = 'N'
          ORDER BY a.fecEntrada DESC
      """)
  List<AsistenciaHistorialResponseDTO> historialPorUsuario(@Param("idUsuario") Long idUsuario);

  @Query(value = "SELECT COUNT(*) FROM asistencia a " +
      "WHERE a.id_usuario = :usuarioId " +
      "AND TRUNC(a.fec_entrada) = TRUNC(SYSDATE) " +
      "AND a.mca_baja = 'N'", nativeQuery = true)
  long countCheckInToday(@Param("usuarioId") Long usuarioId);

  @Query(value = "SELECT COUNT(*) FROM asistencia a " +
      "WHERE a.id_usuario = :usuarioId " +
      "AND TRUNC(a.fec_entrada) = TRUNC(SYSDATE) " +
      "AND a.fec_salida IS NOT NULL " +
      "AND a.mca_baja = 'N'", nativeQuery = true)
  long countCheckOutToday(@Param("usuarioId") Long usuarioId);

  @Query(value = """
          SELECT *
          FROM asistencia a
          WHERE a.id_usuario = :idUsuario
            AND a.mca_baja = 'N'
            AND (:fechaInicio IS NULL OR TRUNC(a.fec_entrada) >= :fechaInicio)
            AND (:fechaFin IS NULL OR TRUNC(a.fec_entrada) <= :fechaFin)
          ORDER BY a.fec_entrada DESC
      """, nativeQuery = true)
  List<Asistencia> historialEmpleado(
      @Param("idUsuario") Long idUsuario,
      @Param("fechaInicio") Date fechaInicio,
      @Param("fechaFin") Date fechaFin);

  @Query(value = """
          SELECT *
          FROM asistencia a
          WHERE a.mca_baja = 'N'
            AND (:#{#idUsuario == null} = TRUE OR id_usuario = :idUsuario)
            AND (:fechaInicio IS NULL OR TRUNC(a.fec_entrada) >= :fechaInicio)
            AND (:fechaFin IS NULL OR TRUNC(a.fec_entrada) <= :fechaFin)
          ORDER BY a.fec_entrada DESC
      """, nativeQuery = true)
  List<Asistencia> historialAdmin(
      @Param("idUsuario") Long idUsuario,
      @Param("fechaInicio") Date fechaInicio,
      @Param("fechaFin") Date fechaFin);

}
