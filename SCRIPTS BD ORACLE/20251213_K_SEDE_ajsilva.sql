create or replace PACKAGE k_sede
AS
   /*------------------------ Version 1.00 ------------------------*/
   --
   /*------------------------ Descripción -------------------------
   ||
   || Package responsable de la gestión de la sede para el módulo
   || de qrtoken.
   ----------------------------------------------------------------*/
   --
   /*------------------------ Modificación ------------------------
   ||
   || 12/12/2025 -- AJSILVA -- 1.00
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   ||                      SECCIÓN DE SEDE
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   || p_crear_sede: Creamos una sede
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_crear_sede ( p_nombre        IN   sede.nombre       %TYPE    ,
                            p_direccion     IN   sede.direccion    %TYPE    ,
                            p_id_sede      OUT   sede.id_sede      %TYPE    ,
                            p_cod_result   OUT   NUMBER                     ,
                            p_msg_result   OUT   VARCHAR2                   );
   --
   /* -------------------------------------------------------------
   || p_cambiar_estado: Cambiamos el estado de la sede
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_cambiar_estado ( p_id_sede         IN   sede.id_sede   %TYPE    ,
                                p_cod_result     OUT   NUMBER                  ,
                                p_msg_result     OUT   VARCHAR2                );
   --
   /* -------------------------------------------------------------
   || f_listar_sedes: Mostramos todas las sedes
   ----------------------------------------------------------------*/
   --
   FUNCTION f_listar_sedes ( p_cod_result    OUT   NUMBER      ,
                             p_msg_result    OUT   VARCHAR2    )
   --
   RETURN SYS_REFCURSOR;
   --
   /* -------------------------------------------------------------
   || f_validar_sede: Validamos una sede
   ----------------------------------------------------------------*/
   --
   FUNCTION f_validar_sede ( p_id_sede        IN   sede.id_sede   %TYPE    ,
                             p_cod_result    OUT   NUMBER                  ,
                             p_msg_result    OUT   VARCHAR2                ) 
   --
   RETURN BOOLEAN;
   --
END k_sede;

create or replace PACKAGE BODY k_sede
AS
   /*------------------------ Version 1.00 ------------------------*/
   --
   /*------------------------ Descripción -------------------------
   ||
   || Package responsable de la gestión de la sede para el módulo
   || de qrtoken.
   ----------------------------------------------------------------*/
   --
   /*------------------------ Modificación ------------------------
   ||
   || 12/12/2025 -- AJSILVA -- 1.00
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   ||                      SECCIÓN DE SEDE
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   || p_crear_sede: Creamos una sede
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_crear_sede ( p_nombre        IN   sede.nombre       %TYPE    ,
                            p_direccion     IN   sede.direccion    %TYPE    ,
                            p_id_sede      OUT   sede.id_sede      %TYPE    ,
                            p_cod_result   OUT   NUMBER                     ,
                            p_msg_result   OUT   VARCHAR2                   )
   --
   IS
   --
   BEGIN
      --
      INSERT INTO sede 
         (
            id_sede     ,
            nombre      ,
            direccion   ,
            mca_estado
         ) 
      VALUES
         (
            seq_sede.NEXTVAL  ,
            UPPER(p_nombre)   ,
            p_direccion       ,
            'A'
         )
      RETURNING id_sede INTO p_id_sede;
      --
      p_cod_result := 1;
      p_msg_result := 'SEDE CREADA';
      --
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         --
         p_cod_result := 0;
         p_msg_result := 'YA EXISTE UNA SEDE CON ESE NOMBRE';
         --
      WHEN OTHERS THEN
         --
         p_cod_result      := 2 ;
         p_msg_result      := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         --
   END p_crear_sede;
   --
   /* -------------------------------------------------------------
   || p_cambiar_estado: Cambiamos el estado de la sede
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_cambiar_estado ( p_id_sede         IN   sede.id_sede   %TYPE    ,
                                p_cod_result     OUT   NUMBER                  ,
                                p_msg_result     OUT   VARCHAR2                )
   --
   IS
   --
   BEGIN
      --
      UPDATE sede
      SET mca_estado = 
         CASE 
            WHEN mca_estado = 'A' THEN 
               'I' 
            ELSE 
               'A'
            END
      WHERE id_sede = p_id_sede;
      --
      IF SQL%ROWCOUNT = 0 THEN
         --
         p_cod_result := 0;
         p_msg_result := 'SEDE NO EXISTE';
         RETURN;
         --
      END IF;
      --
      p_cod_result := 1;
      p_msg_result := 'ESTADO DE SEDE ACTUALIZADO';
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result      := 2 ;
         p_msg_result      := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         --
   END p_cambiar_estado;
   --
   /* -------------------------------------------------------------
   || f_listar_sedes: Mostramos todas las sedes
   ----------------------------------------------------------------*/
   --
   FUNCTION f_listar_sedes ( p_cod_result    OUT   NUMBER      ,
                             p_msg_result    OUT   VARCHAR2    )
   --
   RETURN SYS_REFCURSOR
   --
   IS
      --
      l_cursor SYS_REFCURSOR;
      --
   BEGIN
      --
      OPEN l_cursor FOR
         SELECT id_sede, nombre, direccion, mca_estado
         FROM sede
         WHERE mca_estado = 'A'
         ORDER BY nombre;
      --
      p_cod_result := 1;
      p_msg_result := 'SEDES LISTADAS';
      RETURN l_cursor;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result      := 2 ;
         p_msg_result      := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         --
   END f_listar_sedes;
   --
   /* -------------------------------------------------------------
   || f_validar_sede: Validamos una sede
   ----------------------------------------------------------------*/
   --
   FUNCTION f_validar_sede ( p_id_sede        IN   sede.id_sede   %TYPE    ,
                             p_cod_result    OUT   NUMBER                  ,
                             p_msg_result    OUT   VARCHAR2                ) 
   --
   RETURN BOOLEAN
   --
   IS
      --
      l_estado sede.mca_estado%TYPE;
      --
   BEGIN
      --
      SELECT mca_estado
      INTO l_estado
      FROM sede
      WHERE id_sede = p_id_sede;
      --
      IF l_estado <> 'A' THEN
         --
         p_cod_result := 0;
         p_msg_result := 'SEDE INACTIVA';
         RETURN FALSE;
         --
      END IF;
      --
      p_cod_result := 1;
      p_msg_result := 'SEDE VALIDA';
      RETURN TRUE;
      --
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         --
         p_cod_result      := 0;
         p_msg_result      := 'SEDE NO EXISTE';
         RETURN FALSE;
         --
      WHEN OTHERS THEN
         --
         p_cod_result      := 2 ;
         p_msg_result      := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         --
   END f_validar_sede;
   --
END k_sede;