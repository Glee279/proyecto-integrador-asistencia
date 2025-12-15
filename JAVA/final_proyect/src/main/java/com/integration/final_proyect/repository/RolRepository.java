package com.integration.final_proyect.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.integration.final_proyect.models.Rol;

@Repository
public interface RolRepository extends JpaRepository<Rol, Long>{

}
