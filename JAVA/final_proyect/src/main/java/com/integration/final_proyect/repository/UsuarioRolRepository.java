package com.integration.final_proyect.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.integration.final_proyect.models.UsuarioRol;

@Repository
public interface UsuarioRolRepository extends JpaRepository<UsuarioRol, Long>{

    List<UsuarioRol> findByUsuario_IdUsuario(Long idUsuario);

}
