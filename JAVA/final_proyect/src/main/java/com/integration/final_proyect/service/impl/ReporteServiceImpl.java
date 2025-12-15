package com.integration.final_proyect.service.impl;

import java.sql.CallableStatement;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.integration.final_proyect.dto.reporte.ReporteAsistenciaDTO;
import com.integration.final_proyect.dto.reporte.ReportePuntualidadDTO;
import com.integration.final_proyect.exception.ValidatedRequestException;
import com.integration.final_proyect.service.ReporteService;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import oracle.jdbc.OracleTypes;

@Service
public class ReporteServiceImpl implements ReporteService{

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    @Transactional(readOnly = true)
    public List<ReporteAsistenciaDTO> reporteAsistencia(Long idUsuario, Long idSede, LocalDate fecIni, LocalDate fecFin) {

        return entityManager.unwrap(Session.class).doReturningWork(conn -> {

            CallableStatement cs = conn.prepareCall(
                    "{ ? = call k_reporte.f_rep_asistencia(?,?,?,?,?,?) }");

            cs.registerOutParameter(1, OracleTypes.CURSOR);

            if (idUsuario != null) cs.setLong(2, idUsuario);
            else cs.setNull(2, Types.NUMERIC);

            if (idSede != null) cs.setLong(3, idSede);
            else cs.setNull(3, Types.NUMERIC);

            cs.setDate(4, Date.valueOf(fecIni));
            cs.setDate(5, Date.valueOf(fecFin));

            cs.registerOutParameter(6, Types.NUMERIC);
            cs.registerOutParameter(7, Types.VARCHAR);

            cs.execute();

            int cod = cs.getInt(6);
            String msg = cs.getString(7);

            if (cod != 1) {
                throw new ValidatedRequestException(msg);
            }

            ResultSet rs = (ResultSet) cs.getObject(1);
            List<ReporteAsistenciaDTO> lista = new ArrayList<>();

            while (rs.next()) {

                Timestamp fecEntradaTs = rs.getTimestamp("fec_entrada");
                Timestamp fecSalidaTs  = rs.getTimestamp("fec_salida");

                lista.add(ReporteAsistenciaDTO.builder()
                        .idAsistencia(rs.getLong("id_asistencia"))
                        .idUsuario(rs.getLong("id_usuario"))
                        .nombreCompleto(rs.getString("nombre_completo"))
                        .idSede(rs.getLong("id_sede"))
                        .fecEntrada(fecEntradaTs != null ? fecEntradaTs.toLocalDateTime() : null)
                        .fecSalida(fecSalidaTs != null ? fecSalidaTs.toLocalDateTime() : null)
                        .tipo(rs.getString("tip_asistencia"))
                        .estado(rs.getString("mca_estado"))
                        .build());
            }

            rs.close();
            return lista;
        });
    }

    @Override
    @Transactional(readOnly = true)
    public List<ReportePuntualidadDTO> reportePuntualidad(Long idUsuario, LocalDate fecIni, LocalDate fecFin) {

        return entityManager.unwrap(Session.class).doReturningWork(conn -> {

            CallableStatement cs = conn.prepareCall(
                    "{ ? = call k_reporte.f_rep_puntualidad(?,?,?,?,?) }");

            cs.registerOutParameter(1, OracleTypes.CURSOR);

            if (idUsuario != null) cs.setLong(2, idUsuario);
            else cs.setNull(2, Types.NUMERIC);

            cs.setDate(3, Date.valueOf(fecIni));
            cs.setDate(4, Date.valueOf(fecFin));

            cs.registerOutParameter(5, Types.NUMERIC);
            cs.registerOutParameter(6, Types.VARCHAR);

            cs.execute();

            int cod = cs.getInt(5);
            String msg = cs.getString(6);

            if (cod != 1) {
                throw new ValidatedRequestException(msg);
            }

            ResultSet rs = (ResultSet) cs.getObject(1);
            List<ReportePuntualidadDTO> lista = new ArrayList<>();

            while (rs.next()) {

                Timestamp fecEntradaTs = rs.getTimestamp("fec_entrada");

                lista.add(ReportePuntualidadDTO.builder()
                        .idUsuario(rs.getLong("id_usuario"))
                        .nombreCompleto(rs.getString("nombre_completo"))
                        .fecEntrada(fecEntradaTs != null ? fecEntradaTs.toLocalDateTime() : null)
                        .horaProgramada(rs.getString("hora_programada"))
                        .minutosTardanza(rs.getInt("minutos_tardanza"))
                        .estadoPuntualidad(rs.getString("estado_puntualidad"))
                        .build());
            }

            rs.close();
            return lista;
        });
    }

}
