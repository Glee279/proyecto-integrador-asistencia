package com.integration.final_proyect.service.impl;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;

import org.hibernate.Session;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.integration.final_proyect.dto.qr_token.QrActivoResponseDTO;
import com.integration.final_proyect.dto.qr_token.QrTokenCreateRequestDTO;
import com.integration.final_proyect.dto.qr_token.QrTokenResponseDTO;
import com.integration.final_proyect.dto.qr_token.QrTokenValidarResponseDTO;
import com.integration.final_proyect.exception.ValidatedRequestException;
import com.integration.final_proyect.service.QrTokenService;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import oracle.jdbc.OracleTypes;

@Service
public class QrTokenServiceImpl implements QrTokenService {

    @PersistenceContext
    private EntityManager entityManager;

    private QrTokenResponseDTO obtenerQrPorId(Long idQr) {

        return entityManager.unwrap(Session.class).doReturningWork(conn -> {

            String sql = """
                        SELECT
                            id_qr,
                            codigo_qr,
                            TO_CHAR(fec_generado, 'YYYY-MM-DD HH24:MI:SS') AS fec_generado,
                            TO_CHAR(fec_expira,   'YYYY-MM-DD HH24:MI:SS') AS fec_expira,
                            id_sede,
                            mca_estado
                        FROM qr_token
                        WHERE id_qr = ?
                    """;

            try (var ps = conn.prepareStatement(sql)) {

                ps.setLong(1, idQr);
                var rs = ps.executeQuery();

                if (!rs.next()) {
                    throw new ValidatedRequestException("QR no encontrado");
                }

                return QrTokenResponseDTO.builder()
                        .idQr(rs.getLong("id_qr"))
                        .codigoQr(rs.getString("codigo_qr"))
                        .fecGenerado(rs.getString("fec_generado"))
                        .fecExpira(rs.getString("fec_expira"))
                        .idSede(rs.getLong("id_sede"))
                        .estado(rs.getString("mca_estado"))
                        .build();
            }
        });
    }

    @Override
    @Transactional
    public QrTokenResponseDTO generarQr(QrTokenCreateRequestDTO dto) {

        StoredProcedureQuery sp = entityManager
                .createStoredProcedureQuery("K_QR_TOKEN.p_generar_qr");

        sp.registerStoredProcedureParameter("p_id_sede", Long.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_minutos", Integer.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_id_qr", Long.class, ParameterMode.OUT);
        sp.registerStoredProcedureParameter("p_codigo_qr", String.class, ParameterMode.OUT);
        sp.registerStoredProcedureParameter("p_cod_result", Integer.class, ParameterMode.OUT);
        sp.registerStoredProcedureParameter("p_msg_result", String.class, ParameterMode.OUT);

        sp.setParameter("p_id_sede", dto.getIdSede());
        sp.setParameter("p_minutos", dto.getMinutos());

        sp.execute();

        Integer cod = (Integer) sp.getOutputParameterValue("p_cod_result");
        String msg = (String) sp.getOutputParameterValue("p_msg_result");

        if (cod == null || cod != 1) {
            throw new ValidatedRequestException(msg);
        }

        Long idQr = (Long) sp.getOutputParameterValue("p_id_qr");
        return obtenerQrPorId(idQr);

    }

    @Override
    @Transactional(readOnly = true)
    public QrTokenValidarResponseDTO validarQr(String codigoQr) {

        return entityManager.unwrap(Session.class).doReturningWork(conn -> {

            String sql = "{ ? = call K_QR_TOKEN.f_validar_qr(?, ?, ?, ?) }";

            try (CallableStatement cs = conn.prepareCall(sql)) {

                cs.registerOutParameter(1, Types.BOOLEAN);
                cs.setString(2, codigoQr);
                cs.registerOutParameter(3, Types.BIGINT);
                cs.registerOutParameter(4, Types.INTEGER);
                cs.registerOutParameter(5, Types.VARCHAR);

                cs.execute();

                boolean valido = cs.getBoolean(1);
                int cod = cs.getInt(4);
                String msg = cs.getString(5);

                if (cod == 2) {
                    throw new ValidatedRequestException(msg);
                }

                return QrTokenValidarResponseDTO.builder()
                        .valido(valido)
                        .idSede(valido ? cs.getLong(3) : null)
                        .build();
            }
        });
    }

    @Override
    @Transactional
    public void expirarQr(Long idQr) {

        StoredProcedureQuery sp = entityManager
                .createStoredProcedureQuery("K_QR_TOKEN.p_expirar_qr");

        sp.registerStoredProcedureParameter("p_id_qr", Long.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_cod_result", Integer.class, ParameterMode.OUT);
        sp.registerStoredProcedureParameter("p_msg_result", String.class, ParameterMode.OUT);

        sp.setParameter("p_id_qr", idQr);

        sp.execute();

        Integer cod = (Integer) sp.getOutputParameterValue("p_cod_result");
        String msg = (String) sp.getOutputParameterValue("p_msg_result");

        if (cod == null || cod != 1) {
            throw new ValidatedRequestException(msg);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public QrActivoResponseDTO obtenerQrActivoPorSede(Long idSede) {

        return entityManager.unwrap(Session.class).doReturningWork(conn -> {

            String sql = "{ ? = call K_QR_TOKEN.f_qr_activo_sede(?, ?, ?) }";

            try (CallableStatement cs = conn.prepareCall(sql)) {

                cs.registerOutParameter(1, OracleTypes.CURSOR);
                cs.setLong(2, idSede);
                cs.registerOutParameter(3, Types.INTEGER);
                cs.registerOutParameter(4, Types.VARCHAR);

                cs.execute();

                int cod = cs.getInt(3);
                String msg = cs.getString(4);

                if (cod != 1) {
                    throw new ValidatedRequestException(msg);
                }

                try (ResultSet rs = (ResultSet) cs.getObject(1)) {

                    if (!rs.next()) {
                        throw new ValidatedRequestException("No se pudo obtener QR activo");
                    }

                    return QrActivoResponseDTO.builder()
                            .idQr(rs.getLong("id_qr"))
                            .codigoQr(rs.getString("codigo_qr"))
                            .idSede(rs.getLong("id_sede"))
                            .fecGenerado(toLocalDateTime(rs.getTimestamp("fec_generado")))
                            .fecExpira(toLocalDateTime(rs.getTimestamp("fec_expira")))
                            .estado(rs.getString("mca_estado"))
                            .build();
                }

            } catch (SQLException e) {
                throw new RuntimeException("Error al obtener QR activo", e);
            }
        });
    }

    private static java.time.LocalDateTime toLocalDateTime(Timestamp ts) {
        return ts != null ? ts.toLocalDateTime() : null;
    }

}
