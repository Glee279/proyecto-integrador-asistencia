create or replace PACKAGE k_reporte
AS
   /*------------------------ Version 1.00 ------------------------*/
   --
   /*------------------------ Descripción -------------------------
   ||
   || Package responsable de la gestión de reportes del
   || módulo de reportes.
   ----------------------------------------------------------------*/
   --
   /*------------------------ Modificación ------------------------
   ||
   || 13/12/2025 -- AJSILVA -- 1.00
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   ||                      SECCIÓN DE REPORTE
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   || f_rep_asistencia: Reporte de asistencia de usuario en
   || una sede dentro de un rango
   --------------------------------------------------------------*/
   FUNCTION f_rep_asistencia ( p_id_usuario      IN   asistencia.id_usuario   %TYPE ,
                               p_id_sede         IN   asistencia.id_sede      %TYPE ,
                               p_fec_ini         IN   DATE                          ,
                               p_fec_fin         IN   DATE                          ,
                               p_cod_result     OUT   NUMBER                        ,
                               p_msg_result     OUT   VARCHAR2                      )
   --
   RETURN SYS_REFCURSOR;
   --
   /* -------------------------------------------------------------
   || f_rep_puntualidad: Reporte de puntualidad del usuario
   --------------------------------------------------------------*/
   FUNCTION f_rep_puntualidad ( p_id_usuario     IN      asistencia.id_usuario   %TYPE ,
                                p_fec_ini        IN      DATE                          ,
                                p_fec_fin        IN      DATE                          ,
                                p_cod_result    OUT      NUMBER                        ,
                                p_msg_result    OUT      VARCHAR2                      )
   --
   RETURN SYS_REFCURSOR;
   --
END k_reporte;

create or replace PACKAGE BODY k_reporte
AS
   /*------------------------ Version 1.00 ------------------------*/
   --
   /*------------------------ Descripción -------------------------
   ||
   || Package responsable de la gestión de reportes del
   || módulo de reportes.
   ----------------------------------------------------------------*/
   --
   /*------------------------ Modificación ------------------------
   ||
   || 13/12/2025 -- AJSILVA -- 1.00
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   ||                      SECCIÓN DE REPORTE
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   || f_rep_asistencia: Reporte de asistencia de usuario en
   || una sede dentro de un rango
   --------------------------------------------------------------*/
   FUNCTION f_rep_asistencia ( p_id_usuario      IN   asistencia.id_usuario   %TYPE ,
                               p_id_sede         IN   asistencia.id_sede      %TYPE ,
                               p_fec_ini         IN   DATE                          ,
                               p_fec_fin         IN   DATE                          ,
                               p_cod_result     OUT   NUMBER                        ,
                               p_msg_result     OUT   VARCHAR2                      )
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
         SELECT
            a.id_asistencia   ,
            a.id_usuario      ,
            b.apel_pat    || ' ' || b.apel_mat    || ', ' ||
            b.pri_nombre  || ' ' || b.seg_nombre  AS nombre_completo,
            a.id_sede         ,
            a.fec_entrada     ,
            a.fec_salida      ,
            a.tip_asistencia  ,
            a.mca_estado
         FROM asistencia a, usuario b
         WHERE a.id_usuario   =  b.id_usuario
           AND ( p_id_usuario IS NULL OR a.id_usuario = p_id_usuario )
           AND ( p_id_sede IS NULL OR a.id_sede = p_id_sede )
           AND TRUNC(a.fec_entrada) BETWEEN TRUNC(p_fec_ini) 
                                        AND TRUNC(p_fec_fin)
         ORDER BY a.fec_entrada;
      --
      p_cod_result := 1;
      p_msg_result := 'REPORTE DE ASISTENCIA';
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
END f_rep_asistencia;
   --
   /* -------------------------------------------------------------
   || f_rep_puntualidad: Reporte de puntualidad del usuario
   --------------------------------------------------------------*/
   FUNCTION f_rep_puntualidad ( p_id_usuario     IN      asistencia.id_usuario   %TYPE ,
                                p_fec_ini        IN      DATE                          ,
                                p_fec_fin        IN      DATE                          ,
                                p_cod_result    OUT      NUMBER                        ,
                                p_msg_result    OUT      VARCHAR2                      )
   --
   RETURN SYS_REFCURSOR
   --
   IS
      --
      l_rec_cursor      SYS_REFCURSOR     ;
      l_tolerancia_min  NUMBER            ;
      --
      l_cod_result      NUMBER            ;
      l_msg_result      VARCHAR2(2000)    ;
      --
   BEGIN
      --
      l_tolerancia_min  := 15 ;
      --
      l_cod_result      := 0  ;
      l_msg_result      := 'FUNCION EJECUTADA EXITOSAMENTE' ;
      --
      OPEN l_rec_cursor FOR
         SELECT
            a.id_usuario,
            b.apel_pat || ' ' || b.apel_mat || ', ' ||
            b.pri_nombre || ' ' || b.seg_nombre AS nombre_completo,
            a.fec_entrada,
            b.hora_ini AS hora_programada,
            --
            CASE 
               WHEN a.fec_entrada IS NULL THEN
                  --
                  NULL
                  --
               ELSE
                  --
                  GREATEST -- DEVUELVE EL VALOR MÁS GRANDE ENTRE 0 Y LO CALCULADO (MINIMO 0)
                     (
                        0, -- VALOR MINIMO (DEVUELVE 0 INCLUSO SI EL CALCULO ES NEGATIVO)
                        ROUND -- REDONDEA LOS MINUTOS CALCULADOS
                           (
                              ( 
                                 a.fec_entrada - -- DIFERENCIA ENTRE FECHA Y HORA DE ENTRADA REGISTRADA CON HORA DE ENTRADA DEL EMPLEADO
                                    ( 
                                       TRUNC(a.fec_entrada) +                          -- FECHA ENTRADA + HORA = 00:00
                                          (
                                             TO_DATE(b.hora_ini,'HH24:MI')  -          -- HORA DE INICIO
                                             TRUNC(TO_DATE(b.hora_ini,'HH24:MI'))      -- FRACCION DECIMAL DE LA HORA
                                          )    
                                    )
                              ) * 1440 -- CONVERTIR A MINUTOS
                           )
                     )
                  --
            END AS minutos_tardanza,
            --
            CASE
               --
               WHEN a.fec_entrada IS NULL THEN 'A'
               WHEN a.fec_entrada <= TRUNC(a.fec_entrada) + (
                                                               TO_DATE(b.hora_ini, 'HH24:MI')
                                                               - TRUNC(TO_DATE(b.hora_ini, 'HH24:MI'))
                                                            ) + NUMTODSINTERVAL(l_tolerancia_min, 'MINUTE') -- AÑADIMOS 15 MINUTOS DE TOLERANCIA
                                                            THEN 'P'
               ELSE 'T'
               --
            END AS estado_puntualidad
            --
         FROM asistencia a, usuario b 
         WHERE a.id_usuario = b.id_usuario
           AND a.id_usuario = p_id_usuario
           AND TRUNC(a.fec_entrada) BETWEEN TRUNC(p_fec_ini) 
                                        AND TRUNC(p_fec_fin)
         ORDER BY a.fec_entrada;
      --
      l_cod_result      := 1  ;
      l_msg_result      := 'REPORTE DE PUNTUALIDAD EXITOSO' ;
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
END f_rep_puntualidad;
   --
END k_reporte;