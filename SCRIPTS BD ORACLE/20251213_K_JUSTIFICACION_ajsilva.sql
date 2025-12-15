create or replace PACKAGE k_justificacion
AS
   /*------------------------ Version 1.00 ------------------------*/
   --
   /*------------------------ Descripción -------------------------
   ||
   || Package responsable de la gestión de la justificacion del
   ||  modulo de justificacion.
   ----------------------------------------------------------------*/
   --
   /*------------------------ Modificación ------------------------
   ||
   || 09/12/2025 -- AJSILVA -- 1.00
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   ||                  SECCIÓN DE JUSTIFICACION
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   || f_existe_justificacion: Valida si ya existe justificación
   || previa para la fecha
   ----------------------------------------------------------------*/
   --
   FUNCTION f_existe_justificacion ( p_id_usuario    IN     justificacion.id_usuario   %TYPE ,
                                     p_fec_evento    IN     justificacion.fec_evento   %TYPE ,
                                     p_cod_result   OUT     NUMBER                           ,
                                     p_msg_result   OUT     VARCHAR2                         )
   --
   RETURN NUMBER;
   --
   /* -------------------------------------------------------------
   || f_listar_justificaciones: Obtener justificaciones 
   || por usuario y fecha
   ----------------------------------------------------------------*/
   --
   FUNCTION f_listar_justificaciones ( p_id_usuario    IN   justificacion.id_usuario   %TYPE ,
                                       p_fec_ini       IN   justificacion.fec_evento   %TYPE ,
                                       p_fec_fin       IN   justificacion.fec_evento   %TYPE ,
                                       p_cod_result   OUT   NUMBER                           ,
                                       p_msg_result   OUT   VARCHAR2                         ) 
   --
   RETURN SYS_REFCURSOR;
   --
   /* -------------------------------------------------------------
   || p_registrar_justificacion: Registrar justificación
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_registrar_justificacion ( p_id_usuario         IN  justificacion.id_usuario         %TYPE ,
                                         p_titulo             IN  justificacion.titulo             %TYPE ,
                                         p_descripcion        IN  justificacion.descripcion        %TYPE ,
                                         p_fec_evento         IN  justificacion.fec_evento         %TYPE ,
                                         p_tip_justificacion  IN  justificacion.tip_justificacion  %TYPE ,
                                         p_archivo_url        IN  justificacion.archivo_url        %TYPE ,
                                         p_id_justificacion  OUT  justificacion.id_justificacion   %TYPE ,
                                         p_cod_result        OUT  NUMBER                                 ,
                                         p_msg_result        OUT  VARCHAR2                               );
   --
   /* -------------------------------------------------------------
   || p_revisar_justificacion: Aceptar o Rechazar 
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_revisar_justificacion ( p_id_justificacion   IN    justificacion.id_justificacion   %TYPE ,
                                       p_revision           IN    justificacion.revision           %TYPE ,
                                       p_estado             IN    justificacion.mca_estado         %TYPE ,
                                       p_comentario         IN    justificacion.comment_revision   %TYPE ,
                                       p_cod_result        OUT    NUMBER                                 ,
                                       p_msg_result        OUT    VARCHAR2                               );
   --
   /* -------------------------------------------------------------
   || f_listar_justificaciones_admin
   || Listado general para ADMIN con filtros opcionales
   ---------------------------------------------------------------*/
    FUNCTION f_listar_justificaciones_admin ( p_fec_ini          IN     justificacion.fec_evento    %TYPE   ,
                                              p_fec_fin          IN     justificacion.fec_evento    %TYPE   ,
                                              p_id_usuario       IN     justificacion.id_usuario    %TYPE   ,
                                              p_estado           IN     justificacion.mca_estado    %TYPE   ,
                                              p_cod_result      OUT     NUMBER                              ,
                                              p_msg_result      OUT     VARCHAR2                            )
    --
    RETURN SYS_REFCURSOR;
    --
END k_justificacion;

create or replace PACKAGE BODY k_justificacion
AS
   /*------------------------ Version 1.00 ------------------------*/
   --
   /*------------------------ Descripción -------------------------
   ||
   || Package responsable de la gestión de la justificacion del
   ||  modulo de justificacion.
   ----------------------------------------------------------------*/
   --
   /*------------------------ Modificación ------------------------
   ||
   || 09/12/2025 -- AJSILVA -- 1.00
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   ||                  SECCIÓN DE JUSTIFICACION
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   || f_existe_justificacion: Valida si ya existe justificación
   || previa para la fecha
   ----------------------------------------------------------------*/
   --
   FUNCTION f_existe_justificacion ( p_id_usuario    IN     justificacion.id_usuario   %TYPE ,
                                     p_fec_evento    IN     justificacion.fec_evento   %TYPE ,
                                     p_cod_result   OUT     NUMBER                           ,
                                     p_msg_result   OUT     VARCHAR2                         )
   --
   RETURN NUMBER
   --
   IS
      --
      l_cantidad        NUMBER            ;
      --
      l_cod_result      NUMBER            ;
      l_msg_result      VARCHAR2(2000)    ;
      --
   BEGIN
      --
      l_cantidad        := 0  ;
      --
      l_cod_result      := 0  ;
      l_msg_result      := 'FUNCION EJECUTADA EXITOSAMENTE' ;
      --
      SELECT COUNT(*)
      INTO l_cantidad
      FROM justificacion
      WHERE id_usuario = p_id_usuario
        AND TRUNC(fec_evento) = TRUNC(p_fec_evento);
      --
      IF l_cantidad > 0 THEN
         --
         l_cod_result      := 1  ;
         l_msg_result      := 'YA EXISTE JUSTIFICACION' ;
         --
      ELSE
         --
         l_cod_result      := 1  ;
         l_msg_result      := 'NO EXISTE JUSTIFICACION' ;
         --
      END IF;
      --
      p_cod_result      := l_cod_result   ;
      p_msg_result      := l_msg_result   ;
      --
      RETURN l_cantidad;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result   := 2 ;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         RETURN NULL;
         --
   END f_existe_justificacion;
   --
   /* -------------------------------------------------------------
   || f_listar_justificaciones: Obtener justificaciones 
   || por usuario y fecha
   ----------------------------------------------------------------*/
   --
   FUNCTION f_listar_justificaciones ( p_id_usuario    IN   justificacion.id_usuario   %TYPE ,
                                       p_fec_ini       IN   justificacion.fec_evento   %TYPE ,
                                       p_fec_fin       IN   justificacion.fec_evento   %TYPE ,
                                       p_cod_result   OUT   NUMBER                           ,
                                       p_msg_result   OUT   VARCHAR2                         ) 
   --
   RETURN SYS_REFCURSOR
   --
   IS
      --
      l_rec_cursor      SYS_REFCURSOR     ;
      --
      l_cod_result      NUMBER            ;
      l_msg_result      VARCHAR2(2000)    ;
      --
   BEGIN
      --
      l_cod_result      := 0  ;
      l_msg_result      := 'FUNCION EJECUTADA EXITOSAMENTE' ;
      --
      OPEN l_rec_cursor FOR
         --
         SELECT 
            id_justificacion     ,
            id_usuario           ,
            titulo               ,
            descripcion          ,
            fec_evento           ,
            fec_reg              ,
            tip_justificacion    ,
            revision             ,
            fec_revision         ,
            comment_revision     ,
            archivo_url          ,
            mca_estado
         FROM justificacion
         WHERE id_usuario = p_id_usuario
           AND TRUNC(fec_evento) BETWEEN TRUNC(p_fec_ini) 
                                     AND TRUNC(p_fec_fin)
          ORDER BY fec_evento DESC;
         --
      --
      l_cod_result      := 1  ;
      l_msg_result      := 'LISTADO CORRECTAMENTE' ;
      --
      p_cod_result      := l_cod_result   ;
      p_msg_result      := l_msg_result   ;
      --
      RETURN l_rec_cursor;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result   := 2 ;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         RETURN NULL;
         --
   END f_listar_justificaciones;
   --
   /* -------------------------------------------------------------
   || p_registrar_justificacion: Registrar justificación
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_registrar_justificacion ( p_id_usuario         IN  justificacion.id_usuario         %TYPE ,
                                         p_titulo             IN  justificacion.titulo             %TYPE ,
                                         p_descripcion        IN  justificacion.descripcion        %TYPE ,
                                         p_fec_evento         IN  justificacion.fec_evento         %TYPE ,
                                         p_tip_justificacion  IN  justificacion.tip_justificacion  %TYPE ,
                                         p_archivo_url        IN  justificacion.archivo_url        %TYPE ,
                                         p_id_justificacion  OUT  justificacion.id_justificacion   %TYPE ,
                                         p_cod_result        OUT  NUMBER                                 ,
                                         p_msg_result        OUT  VARCHAR2                               )
   IS
      --
      l_existe          NUMBER            ;
      --
      l_cod_result      NUMBER            ;
      l_msg_result      VARCHAR2(2000)    ;
      --
   BEGIN
      --
      l_existe          := 0  ;
      --
      l_cod_result      := 0  ;
      l_msg_result      := 'PROCESO EJECUTADO EXITOSAMENTE' ;
      --
      l_existe          := f_existe_justificacion ( p_id_usuario     =>    p_id_usuario   ,
                                                    p_fec_evento     =>    p_fec_evento   ,
                                                    p_cod_result     =>    l_cod_result   ,
                                                    p_msg_result     =>    l_msg_result   );
      --
      IF l_cod_result = 2 THEN
         --
         p_cod_result := 2;
         p_msg_result := l_msg_result;
         RETURN;
         --
      END IF;
      --
      IF l_existe > 0 THEN
         --
         p_cod_result := 0;
         p_msg_result := 'YA EXISTE UNA JUSTIFICACION PARA LA FECHA INDICADA';
         RETURN;
         --
      END IF;
      --
      p_id_justificacion   := seq_justificacion.NEXTVAL;
      --
      INSERT INTO justificacion 
         (
            id_justificacion     ,
            id_usuario           ,
            titulo               ,
            descripcion          ,
            fec_evento           ,
            fec_reg              ,
            tip_justificacion    ,
            archivo_url          ,
            mca_estado
         )
      VALUES 
         (
            p_id_justificacion   ,
            p_id_usuario         ,
            p_titulo             ,
            p_descripcion        ,
            p_fec_evento         ,
            SYSDATE              ,
            p_tip_justificacion  ,
            p_archivo_url        ,
            'P'
         )
      RETURNING id_justificacion INTO p_id_justificacion;
      --
      l_cod_result      := 1  ;
      l_msg_result      := 'JUSTIFICACION REGISTRADA EXITOSAMENTE' ;
      --
      p_cod_result      := l_cod_result   ;
      p_msg_result      := l_msg_result   ;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result   := 2 ;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         --
   END p_registrar_justificacion;
   --
   /* -------------------------------------------------------------
   || p_revisar_justificacion: Aceptar o Rechazar 
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_revisar_justificacion ( p_id_justificacion   IN    justificacion.id_justificacion   %TYPE ,
                                       p_revision           IN    justificacion.revision           %TYPE ,
                                       p_estado             IN    justificacion.mca_estado         %TYPE ,
                                       p_comentario         IN    justificacion.comment_revision   %TYPE ,
                                       p_cod_result        OUT    NUMBER                                 ,
                                       p_msg_result        OUT    VARCHAR2                               )
   IS
      --
      l_cantidad        NUMBER            ;   
      --
      l_cod_result      NUMBER            ;
      l_msg_result      VARCHAR2(2000)    ;
      --
   BEGIN
      --
      l_cod_result      := 0  ;
      l_msg_result      := 'PROCESO EJECUTADO EXITOSAMENTE' ;
      --
      SELECT COUNT(*)
      INTO l_cantidad
      FROM justificacion
      WHERE id_justificacion = p_id_justificacion;
      --
      IF l_cantidad = 0 THEN
         --
         l_cod_result      := 1  ;
         l_msg_result      := 'JUSTIFICACION INEXISTENTE' ;
         RETURN;
         --
      END IF;
      --
      UPDATE justificacion
      SET revision         = p_revision   ,
          mca_estado       = p_estado     ,
          comment_revision = p_comentario ,
          fec_revision     = SYSDATE
      WHERE id_justificacion = p_id_justificacion;
      --
      l_cod_result      := 1  ;
      l_msg_result      := 'JUSTIFICACION REVISADA EXITOSAMENTE' ;
      --
      p_cod_result      := l_cod_result   ;
      p_msg_result      := l_msg_result   ;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result   := 2 ;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         --
   END;
   --
   /* -------------------------------------------------------------
   || f_listar_justificaciones_admin
   || Listado general para ADMIN con filtros opcionales
   ---------------------------------------------------------------*/
    FUNCTION f_listar_justificaciones_admin ( p_fec_ini          IN     justificacion.fec_evento    %TYPE   ,
                                              p_fec_fin          IN     justificacion.fec_evento    %TYPE   ,
                                              p_id_usuario       IN     justificacion.id_usuario    %TYPE   ,
                                              p_estado           IN     justificacion.mca_estado    %TYPE   ,
                                              p_cod_result      OUT     NUMBER                              ,
                                              p_msg_result      OUT     VARCHAR2                            )
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
            --
            SELECT
                j.id_justificacion,
                j.id_usuario,
                j.titulo,
                j.descripcion,
                j.fec_evento,
                j.fec_reg,
                j.tip_justificacion,
                j.revision,
                j.fec_revision,
                j.comment_revision,
                j.archivo_url,
                j.mca_estado
            FROM justificacion j
            WHERE TRUNC(j.fec_evento) BETWEEN TRUNC(p_fec_ini) 
                                          AND TRUNC(p_fec_fin)
              AND (p_id_usuario IS NULL OR j.id_usuario = p_id_usuario)
              AND (p_estado IS NULL OR j.mca_estado = p_estado)
              AND j.mca_baja = 'N'
            ORDER BY j.fec_reg DESC;
        --
        p_cod_result := 1;
        p_msg_result := 'LISTADO RETORNADO';
        --
        RETURN l_cursor;
        --
    EXCEPTION
        WHEN OTHERS THEN
            --
            p_cod_result   := 2 ;
            p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
            RETURN NULL;
            --
    END f_listar_justificaciones_admin;

END k_justificacion;