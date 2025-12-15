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

import com.integration.final_proyect.dto.rol.RolCreateRequestDTO;
import com.integration.final_proyect.dto.rol.RolResponseDTO;
import com.integration.final_proyect.exception.ValidatedRequestException;
import com.integration.final_proyect.service.RolService;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import oracle.jdbc.OracleTypes;

@Service
public class RolServiceImpl implements RolService {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    @Transactional
    public void crearRol(RolCreateRequestDTO dto) {

        // 1.- Crear llamada al procedimiento
        StoredProcedureQuery sp = entityManager
                .createStoredProcedureQuery("K_USUARIO.p_crear_rol");

        // 2.- Registrar parámetros
        sp.registerStoredProcedureParameter("p_nombre", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_cod_result", Integer.class, ParameterMode.OUT);
        sp.registerStoredProcedureParameter("p_msg_result", String.class, ParameterMode.OUT);

        // 3.- Asignar valores
        sp.setParameter("p_nombre", dto.getNombre().toUpperCase());

        // 4.- Ejecutar procedimiento
        sp.execute();

        // 5.- Validar resultado
        Integer cod = (Integer) sp.getOutputParameterValue("p_cod_result");
        String msg = (String) sp.getOutputParameterValue("p_msg_result");

        if (cod == null || cod != 1) {
            throw new ValidatedRequestException(
                msg != null ? msg : "Error al crear rol"
            );
        }
    }

    @Override
    @Transactional
    public void asignarRol(Long idUsuario, Long idRol) {

        // 1. llamar al procedimiento
        StoredProcedureQuery sp = entityManager
                .createStoredProcedureQuery("K_USUARIO.p_asignar_rol");

        // 2. Registrar parámetros
        sp.registerStoredProcedureParameter("p_id_usuario", Long.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_id_rol", Long.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_cod_result", Integer.class, ParameterMode.OUT);
        sp.registerStoredProcedureParameter("p_msg_result", String.class, ParameterMode.OUT);

        // 3. Setear valores
        sp.setParameter("p_id_usuario", idUsuario);
        sp.setParameter("p_id_rol", idRol);

        // 4. Ejecutar
        sp.execute();

        // 5. Validar resultado
        Integer cod = (Integer) sp.getOutputParameterValue("p_cod_result");
        String msg = (String) sp.getOutputParameterValue("p_msg_result");

        if (cod == null || cod != 1) {
            throw new RuntimeException(
                msg != null ? msg : "Error al asignar rol"
            );
        }
    }

    @Override
    @Transactional
    public void quitarRol(Long idUsuario, Long idRol) {

        // 1. llamar al procedimiento
        StoredProcedureQuery sp = entityManager
                .createStoredProcedureQuery("K_USUARIO.p_quitar_rol");

        // 2. Registrar parámetros
        sp.registerStoredProcedureParameter("p_id_usuario", Long.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_id_rol", Long.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_cod_result", Integer.class, ParameterMode.OUT);
        sp.registerStoredProcedureParameter("p_msg_result", String.class, ParameterMode.OUT);

        // 3. Setear valores
        sp.setParameter("p_id_usuario", idUsuario);
        sp.setParameter("p_id_rol", idRol);

        // 4. Ejecutar
        sp.execute();

        // 5. Validar resultado
        Integer cod = (Integer) sp.getOutputParameterValue("p_cod_result");
        String msg = (String) sp.getOutputParameterValue("p_msg_result");

        if (cod == null || cod != 1) {
            throw new RuntimeException(
                msg != null ? msg : "Error al quitar rol"
            );
        }
    }

    @Override
    @Transactional
    public void actualizarRol(Long idRol, String nombre) {

        // 1. llamar al procedimiento
        StoredProcedureQuery sp = entityManager
                .createStoredProcedureQuery("K_USUARIO.p_actualizar_rol");

        // 2. Registrar parámetros
        sp.registerStoredProcedureParameter("p_id_rol", Long.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_nombre", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_cod_result", Integer.class, ParameterMode.OUT);
        sp.registerStoredProcedureParameter("p_msg_result", String.class, ParameterMode.OUT);

        // 3. Setear valores
        sp.setParameter("p_id_rol", idRol);
        sp.setParameter("p_nombre", nombre);

        // 4. Ejecutar
        sp.execute();

        // 5. Validar resultado
        Integer cod = (Integer) sp.getOutputParameterValue("p_cod_result");
        String msg = (String) sp.getOutputParameterValue("p_msg_result");

        if (cod == null || cod != 1) {
            throw new ValidatedRequestException(msg);
        }
    }

    @Override
    @Transactional
    public void modificarEstadoRol(Long idRol) {

        // 1. llamar al procedimiento
        StoredProcedureQuery sp = entityManager
                .createStoredProcedureQuery("K_USUARIO.p_modificar_estado_rol");

        // 2. Registrar parámetros
        sp.registerStoredProcedureParameter("p_id_rol", Long.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_cod_result", Integer.class, ParameterMode.OUT);
        sp.registerStoredProcedureParameter("p_msg_result", String.class, ParameterMode.OUT);

        // 3. Setear valores
        sp.setParameter("p_id_rol", idRol);

        // 4. Ejecutar
        sp.execute();

        // 5. Validar resultado
        Integer cod = (Integer) sp.getOutputParameterValue("p_cod_result");
        String msg = (String) sp.getOutputParameterValue("p_msg_result");

        if (cod == null || cod != 1) {
            throw new ValidatedRequestException(msg);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<RolResponseDTO> listarRoles() {

        // 1.- Llamar al procedimiento
        StoredProcedureQuery sp = entityManager
                .createStoredProcedureQuery("K_USUARIO.p_listar_roles");

        // 2.- Registrar cursor de salida
        sp.registerStoredProcedureParameter("p_cursor", void.class, ParameterMode.REF_CURSOR);

        // 3.- Ejecutar función
        sp.execute();

        // 4.- Obtener resultados del cursor
        @SuppressWarnings("unchecked")
        List<Object[]> rows = sp.getResultList();

        // 5.- Mapear
        return rows.stream().map(r ->
            RolResponseDTO.builder()
                .idRol(((Number) r[0]).longValue())
                .nombre((String) r[1])
                .estado(r[2] != null ? r[2].toString() : "")
                .build()
        ).toList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<RolResponseDTO> rolesPorUsuario(Long idUsuario) {

        return entityManager.unwrap(Session.class).doReturningWork(connection -> {

            String sql = "{ ? = call K_USUARIO.f_roles_usuario(?, ?, ?) }";

            try (CallableStatement cs = connection.prepareCall(sql)) {

                cs.registerOutParameter(1, OracleTypes.CURSOR);
                cs.setLong(2, idUsuario);
                cs.registerOutParameter(3, Types.INTEGER);
                cs.registerOutParameter(4, Types.VARCHAR);

                cs.execute();

                int cod = cs.getInt(3);
                String msg = cs.getString(4);

                if (cod != 1) {
                    throw new ValidatedRequestException(msg);
                }

                ResultSet rs = (ResultSet) cs.getObject(1);

                List<RolResponseDTO> roles = new ArrayList<>();

                while (rs.next()) {
                    roles.add(RolResponseDTO.builder()
                            .idRol(rs.getLong("id_rol"))
                            .nombre(rs.getString("nombre"))
                            .estado(rs.getString("mca_estado"))
                            .build());
                }

                rs.close();
                return roles;

            } catch (SQLException e) {
                throw new RuntimeException("Error al obtener roles del usuario", e);
            }
        });
    }

}
