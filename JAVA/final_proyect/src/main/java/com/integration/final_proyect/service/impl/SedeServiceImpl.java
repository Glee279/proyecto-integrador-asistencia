package com.integration.final_proyect.service.impl;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.integration.final_proyect.dto.sede.SedeCreateRequestDTO;
import com.integration.final_proyect.dto.sede.SedeResponseDTO;
import com.integration.final_proyect.exception.ValidatedRequestException;
import com.integration.final_proyect.service.SedeService;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import oracle.jdbc.OracleTypes;

@Service
public class SedeServiceImpl implements SedeService{

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    @Transactional
    public SedeResponseDTO crearSede(SedeCreateRequestDTO dto) {

        StoredProcedureQuery sp = entityManager
            .createStoredProcedureQuery("K_SEDE.p_crear_sede");

        sp.registerStoredProcedureParameter("p_nombre", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_direccion", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_id_sede", Long.class, ParameterMode.OUT);
        sp.registerStoredProcedureParameter("p_cod_result", Integer.class, ParameterMode.OUT);
        sp.registerStoredProcedureParameter("p_msg_result", String.class, ParameterMode.OUT);

        sp.setParameter("p_nombre", dto.getNombre());
        sp.setParameter("p_direccion", dto.getDireccion());

        sp.execute();

        Integer cod = (Integer) sp.getOutputParameterValue("p_cod_result");
        String msg = (String) sp.getOutputParameterValue("p_msg_result");

        if (cod == null || cod != 1) {
            throw new ValidatedRequestException(msg);
        }

        return SedeResponseDTO.builder()
            .idSede((Long) sp.getOutputParameterValue("p_id_sede"))
            .nombre(dto.getNombre())
            .direccion(dto.getDireccion())
            .estado("A")
            .build();
    }

    @Override
    @Transactional(readOnly = true)
    public List<SedeResponseDTO> listarSedes() {

        return entityManager.unwrap(Session.class).doReturningWork(conn -> {

            String sql = "{ ? = call K_SEDE.f_listar_sedes(?, ?) }";

            try (CallableStatement cs = conn.prepareCall(sql)) {

                cs.registerOutParameter(1, OracleTypes.CURSOR);
                cs.registerOutParameter(2, Types.INTEGER);
                cs.registerOutParameter(3, Types.VARCHAR);

                cs.execute();

                int cod = cs.getInt(2);
                String msg = cs.getString(3);

                if (cod != 1) {
                    throw new ValidatedRequestException(msg);
                }

                ResultSet rs = (ResultSet) cs.getObject(1);
                List<SedeResponseDTO> sedes = new ArrayList<>();

                while (rs.next()) {
                    sedes.add(
                        SedeResponseDTO.builder()
                            .idSede(rs.getLong("id_sede"))
                            .nombre(rs.getString("nombre"))
                            .direccion(rs.getString("direccion"))
                            .estado(rs.getString("mca_estado"))
                            .build()
                    );
                }

                rs.close();
                return sedes;

            } catch (SQLException e) {
                throw new RuntimeException("Error al listar sedes", e);
            }
        });
    }

    @Override
    @Transactional
    public void cambiarEstado(Long idSede) {

        StoredProcedureQuery sp = entityManager
            .createStoredProcedureQuery("K_SEDE.p_cambiar_estado");

        sp.registerStoredProcedureParameter("p_id_sede", Long.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_cod_result", Integer.class, ParameterMode.OUT);
        sp.registerStoredProcedureParameter("p_msg_result", String.class, ParameterMode.OUT);

        sp.setParameter("p_id_sede", idSede);

        sp.execute();

        Integer cod = (Integer) sp.getOutputParameterValue("p_cod_result");
        String msg = (String) sp.getOutputParameterValue("p_msg_result");

        if (cod == null || cod != 1) {
            throw new ValidatedRequestException(msg);
        }
    }

}
