-- INDEXS

-- EVITAMOS DOBLES MARCADO ( DOBLE CHECK-IN ) EN EL MISMO DIA
CREATE UNIQUE INDEX UNQ_SIS_USU_FEC 
ON asistencia (
   --
	id_usuario, 
	TRUNC(fec_entrada)
   --
);

-- ÍNDICE PARA OPTIMIZAR CONSULTAS POR FECHA
CREATE INDEX IDX_ASIS_FECHA   
ON asistencia (
   --
   fec_entrada
   --
);

-- ÍNDICE PARA OPTIMIZAR CONSULTAS POR USUARIO
CREATE INDEX IDX_ASIS_USUARIO 
ON asistencia (
   --
   id_usuario
   --
);

-- ÍNDICE PARA OPTIMIZAR CONSULTAS DE JUSTIFICACIONES POR USUARIO
CREATE INDEX IDX_JUST_USUARIO 
ON justificacion (
   --
   id_usuario
   --
);

-- VIEWS

-- VIEW PARA JUSTIFICACIONES PENDIENTES DE AUTORIZACION
CREATE OR REPLACE VIEW vw_justi_pendiente AS
SELECT 
   j.id_justificacion,
   j.id_usuario,
   u.usuario,
   u.pri_nombre,
   u.seg_nombre,
   u.apel_pat,
   u.apel_mat,
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
FROM justificacion j, usuario u
WHERE j.id_usuario = u.id_usuario
  AND j.mca_estado = 'P';