package com.integration.final_proyect.service.impl;

import java.sql.CallableStatement;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.integration.final_proyect.dto.justificacion.JustificacionCreateRequestDTO;
import com.integration.final_proyect.dto.justificacion.JustificacionResponseDTO;
import com.integration.final_proyect.dto.justificacion.JustificacionRevisionRequestDTO;
import com.integration.final_proyect.exception.ValidatedRequestException;
import com.integration.final_proyect.service.JustificacionService;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import oracle.jdbc.OracleTypes;

@Service
public class JustificacionServiceImpl implements JustificacionService {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    @Transactional
    public JustificacionResponseDTO registrar(Long idUsuarioAutenticado, JustificacionCreateRequestDTO dto) {

        return entityManager.unwrap(Session.class).doReturningWork(conn -> {

            CallableStatement cs = conn.prepareCall(
                    "{ call k_justificacion.p_registrar_justificacion(?,?,?,?,?,?,?,?,?) }");

            cs.setLong(1, idUsuarioAutenticado);
            cs.setString(2, dto.getTitulo());
            cs.setString(3, dto.getDescripcion());
            cs.setDate(4, Date.valueOf(dto.getFecEvento()));
            cs.setString(5, dto.getTipJustificacion());
            cs.setString(6, dto.getArchivoUrl());

            cs.registerOutParameter(7, Types.NUMERIC); // id_justificacion
            cs.registerOutParameter(8, Types.NUMERIC); // cod
            cs.registerOutParameter(9, Types.VARCHAR); // msg

            cs.execute();

            int cod = cs.getInt(8);
            String msg = cs.getString(9);

            if (cod != 1) throw new ValidatedRequestException(msg);

            return JustificacionResponseDTO.builder()
                    .idJustificacion(cs.getLong(7))
                    .idUsuario(idUsuarioAutenticado)
                    .titulo(dto.getTitulo())
                    .descripcion(dto.getDescripcion())
                    .fecEvento(dto.getFecEvento())
                    .fecRegistro(LocalDateTime.now())
                    .tipJustificacion(dto.getTipJustificacion())
                    .estado("P")
                    .archivoUrl(dto.getArchivoUrl())
                    .build();
        });
    }

    @Override
    @Transactional(readOnly = true)
    public List<JustificacionResponseDTO> listarPorUsuario(Long idUsuario, LocalDate ini, LocalDate fin) {

        return entityManager.unwrap(Session.class).doReturningWork(conn -> {

            CallableStatement cs = conn.prepareCall(
                    "{ ? = call k_justificacion.f_listar_justificaciones(?,?,?,?,?) }");

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.setLong(2, idUsuario);
            cs.setDate(3, Date.valueOf(ini));
            cs.setDate(4, Date.valueOf(fin));
            cs.registerOutParameter(5, Types.NUMERIC);
            cs.registerOutParameter(6, Types.VARCHAR);

            cs.execute();

            int cod = cs.getInt(5);
            String msg = cs.getString(6);

            if (cod != 1) throw new ValidatedRequestException(msg);

            ResultSet rs = (ResultSet) cs.getObject(1);
            List<JustificacionResponseDTO> lista = new ArrayList<>();

            while (rs.next()) {
                Timestamp tsReg = rs.getTimestamp("fec_reg");
                Timestamp tsRev = rs.getTimestamp("fec_revision");

                lista.add(JustificacionResponseDTO.builder()
                        .idJustificacion(rs.getLong("id_justificacion"))
                        .idUsuario(rs.getLong("id_usuario"))
                        .titulo(rs.getString("titulo"))
                        .descripcion(rs.getString("descripcion"))
                        .fecEvento(rs.getDate("fec_evento") != null ? rs.getDate("fec_evento").toLocalDate() : null)
                        .fecRegistro(tsReg != null ? tsReg.toLocalDateTime() : null)
                        .fecRevision(tsRev != null ? tsRev.toLocalDateTime() : null)
                        .comentario(rs.getString("comment_revision"))
                        .tipJustificacion(rs.getString("tip_justificacion"))
                        .estado(rs.getString("mca_estado"))
                        .archivoUrl(rs.getString("archivo_url"))
                        .build());
            }

            rs.close();
            return lista;
        });
    }

    @Override
    @Transactional
    public void revisar(Long idRevisionAutenticado, JustificacionRevisionRequestDTO dto) {

        entityManager.unwrap(Session.class).doWork(conn -> {

            CallableStatement cs = conn.prepareCall(
                    "{ call k_justificacion.p_revisar_justificacion(?,?,?,?,?,?) }");

            cs.setLong(1, dto.getIdJustificacion());
            cs.setLong(2, idRevisionAutenticado);
            cs.setString(3, dto.getEstado());
            cs.setString(4, dto.getComentario());
            cs.registerOutParameter(5, Types.NUMERIC);
            cs.registerOutParameter(6, Types.VARCHAR);

            cs.execute();

            int cod = cs.getInt(5);
            String msg = cs.getString(6);

            if (cod != 1) throw new ValidatedRequestException(msg);
        });
    }

    @Override
    @Transactional(readOnly = true)
    public List<JustificacionResponseDTO> listarAdmin(LocalDate ini, LocalDate fin, Long idUsuario, String estado) {

        return entityManager.unwrap(Session.class).doReturningWork(conn -> {

            CallableStatement cs = conn.prepareCall(
                    "{ ? = call k_justificacion.f_listar_justificaciones_admin(?,?,?,?,?,?) }");

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.setDate(2, Date.valueOf(ini));
            cs.setDate(3, Date.valueOf(fin));

            if (idUsuario != null) cs.setLong(4, idUsuario);
            else cs.setNull(4, Types.NUMERIC);

            if (estado != null && !estado.isBlank()) cs.setString(5, estado);
            else cs.setNull(5, Types.VARCHAR);

            cs.registerOutParameter(6, Types.NUMERIC);
            cs.registerOutParameter(7, Types.VARCHAR);

            cs.execute();

            int cod = cs.getInt(6);
            String msg = cs.getString(7);

            if (cod != 1) throw new ValidatedRequestException(msg);

            ResultSet rs = (ResultSet) cs.getObject(1);
            List<JustificacionResponseDTO> lista = new ArrayList<>();

            while (rs.next()) {
                Timestamp tsReg = rs.getTimestamp("fec_reg");
                Timestamp tsRev = rs.getTimestamp("fec_revision");

                lista.add(JustificacionResponseDTO.builder()
                        .idJustificacion(rs.getLong("id_justificacion"))
                        .idUsuario(rs.getLong("id_usuario"))
                        .titulo(rs.getString("titulo"))
                        .descripcion(rs.getString("descripcion"))
                        .fecEvento(rs.getDate("fec_evento") != null ? rs.getDate("fec_evento").toLocalDate() : null)
                        .fecRegistro(tsReg != null ? tsReg.toLocalDateTime() : null)
                        .fecRevision(tsRev != null ? tsRev.toLocalDateTime() : null)
                        .comentario(rs.getString("comment_revision"))
                        .tipJustificacion(rs.getString("tip_justificacion"))
                        .estado(rs.getString("mca_estado"))
                        .archivoUrl(rs.getString("archivo_url"))
                        .build());
            }

            rs.close();
            return lista;
        });
    }
}
