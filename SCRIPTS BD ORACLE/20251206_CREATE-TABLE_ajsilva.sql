-- USUARIO
CREATE TABLE usuario (
   --
	id_usuario		NUMBER(10)		NOT NULL		      ,
	usuario 		   VARCHAR2(50)	NOT NULL UNIQUE	,
	pass_usu		   VARCHAR2(128)	NOT NULL		      ,
   salt_usu       VARCHAR2(32)   NOT NULL          ,
	mca_estado		VARCHAR2(1)		NOT NULL		      , -- A = Activo, I = Inactivo
   area           VARCHAR2(50)   NOT NULL          ,
   hora_ini       VARCHAR2(5)    NOT NULL          ,
   hora_fin       VARCHAR2(5)    NOT NULL          ,
   modalidad      VARCHAR2(20)   NOT NULL          , -- PRESENCIAL O REMOTO
	apel_pat		   VARCHAR2(20)	NOT NULL		      ,
	apel_mat		   VARCHAR2(20)	NOT NULL		      ,
	pri_nombre		VARCHAR2(20)	NOT NULL		      ,
   seg_nombre     VARCHAR2(50)       NULL          ,
	dni 			   VARCHAR2(8)		NOT NULL UNIQUE	,
	telefono		   VARCHAR2(9)		NOT NULL		      ,
	direccion		VARCHAR2(100)	NOT NULL		      ,
   correo_per     VARCHAR2(100)  NOT NULL          ,
   correo_cor     VARCHAR2(100)  NOT NULL UNIQUE   ,
   --
	CONSTRAINT PK_USUARIO PRIMARY KEY (
      --
      id_usuario
      --
   )
);

-- ROL
CREATE TABLE rol (
   --
	id_rol      NUMBER(10)		NOT NULL	         ,
	nombre		VARCHAR2(50)	NOT NULL	UNIQUE   ,
   mca_estado	VARCHAR2(1)		NOT NULL		      , -- A = Activo, I = Inactivo
   --
	CONSTRAINT PK_ROL PRIMARY KEY (
      --
      id_rol
      --
   )
);

-- USUARIO_ROL
CREATE TABLE usuario_rol (
   --
	id_usuario_rol		NUMBER(10)	NOT NULL	,
	id_usuario 			NUMBER(10)	NOT NULL	,
	id_rol 				NUMBER(10)	NOT NULL	,
   --
	CONSTRAINT PK_USUARIO_ROL PRIMARY KEY (
      --
      id_usuario_rol
      --
   ),
   CONSTRAINT FK_UR_USUARIO FOREIGN KEY (
      --
      id_usuario
      --
   ) REFERENCES usuario (
      --
      id_usuario
      --
   ),
   CONSTRAINT FK_UR_ROL FOREIGN KEY (
      --
    	id_rol
      --
   ) REFERENCES rol (
      --
    	id_rol
      --
   ),
   CONSTRAINT UNQ_USUARIO_ROL UNIQUE ( -- EVITAMOS ROLES DUPLICADOS POR USUARIO
      --
    	id_usuario,
    	id_rol
      --
   )
);

-- ASISTENCIA
CREATE TABLE asistencia (
   --
	id_asistencia		NUMBER(10)		NOT NULL	      ,
	id_usuario 			NUMBER(10)		NOT NULL	      ,
   id_sede           NUMBER(10)         NULL       ,
	fec_entrada			DATE			   NOT NULL	      ,
	fec_salida			DATE			       NULL		   ,
	mca_estado			VARCHAR2(2)		DEFAULT 'RI'	, -- RI = REGISTRO INCOMPLETO, RC = REGISTRO COMPLETO 
	tip_asistencia		VARCHAR2(10)	NOT NULL	      , -- MANUAL O QR
   mca_baja          VARCHAR2(1)    DEFAULT 'N'    ,
   --
	CONSTRAINT PK_ASISTENCIA PRIMARY KEY (
      --
      id_asistencia
      --
   ),
   CONSTRAINT FK_ASIS_USUARIO FOREIGN KEY (
      --
   	id_usuario
      --
   ) REFERENCES usuario (
      --
   	id_usuario
      --
   )
);

-- SEDE
CREATE TABLE sede (
   --
   id_sede     NUMBER(10)     NOT NULL          ,
   nombre      VARCHAR2(100)  NOT NULL UNIQUE   ,
   direccion   VARCHAR2(300)  NOT NULL          ,
   mca_estado	VARCHAR2(1)		NOT NULL		      , -- A = Activo, I = Inactivo
   --
   CONSTRAINT PK_SEDE PRIMARY KEY (
      --
      id_sede
      --
   )
);

-- QR_TOKEN
CREATE TABLE qr_token (
   --
   id_qr          NUMBER(10)     NOT NULL    ,
   codigo_qr      VARCHAR2(500)  NOT NULL    ,
   fec_generado   DATE           NOT NULL    ,
   fec_expira     DATE           NOT NULL    ,
   id_sede        NUMBER(5)      NOT NULL    ,
   mca_estado     VARCHAR2(1)    NOT NULL    , -- A = Activo, E = Expirado
   --
   CONSTRAINT PK_QR_TOKEN PRIMARY KEY (
      --
      id_qr
      --
   ),
   CONSTRAINT FK_QR_SEDE FOREIGN KEY (
      --
   	id_sede
      --
   ) REFERENCES SEDE (
      --
   	id_sede
      --
   )
);

-- JUSTIFICACION
CREATE TABLE justificacion (
   --
	id_justificacion		NUMBER(10)		NOT NULL	   ,
	id_usuario 				NUMBER(10)		NOT NULL	   , -- USUARIO JUSTIFICADOR
	titulo					VARCHAR2(50)	NOT NULL	   ,
	descripcion				VARCHAR2(1000)	NOT NULL	   ,
   fec_evento           DATE           NOT NULL    ,
	fec_reg		         DATE			   NOT NULL	   ,
	tip_justificacion		VARCHAR2(1)		NOT NULL	   , -- T = TARDANZA, A = AUSENCIA
   revision             NUMBER(10)         NULL    , -- USUARIO QUE ATIENDE LA JUSTIFICACION
   fec_revision         DATE               NULL    ,
   comment_revision     VARCHAR2(1000)     NULL    ,
   archivo_url          VARCHAR2(500)      NULL    ,
	mca_estado				VARCHAR2(1)		DEFAULT 'P'	, -- P = PENDIENTE, A = ACEPTADO, R = RECHAZADO
   mca_baja             VARCHAR2(1)    DEFAULT 'N' ,
   --
	CONSTRAINT PK_JUSTIFICACION PRIMARY KEY (
      --
      id_justificacion
      --
   ),
   CONSTRAINT FK_JUST_USUARIO FOREIGN KEY (
      --
      id_usuario
      --
   ) REFERENCES usuario (
      --
    	id_usuario
      --
   ),
   CONSTRAINT FK_JUST_USUARIO_REV FOREIGN KEY (
      --
      revision
      --
   ) REFERENCES usuario (
      --
    	id_usuario
      --
   )
);

-- LOG_ASISTENCIA
CREATE TABLE log_asistencia (
   --
	id_log_asistencia		NUMBER(10)		NOT NULL		   ,
	id_asistencia 			NUMBER(10)		NOT NULL		   ,
	id_usuario 				NUMBER(10)		NOT NULL		   ,
	accion					VARCHAR2(20)	NOT NULL		   ,
	fec_accion 				DATE DEFAULT SYSDATE NOT NULL	,
   --
	CONSTRAINT PK_LOG_ASISTENCIA PRIMARY KEY (
      --
      id_log_asistencia
      --
   ),
   CONSTRAINT FK_LOGA_ASISTENCIA FOREIGN KEY (
      --
      id_asistencia
      --
   ) REFERENCES asistencia (
      --
    	id_asistencia
      --
   ),
   CONSTRAINT FK_LOGA_USUARIO FOREIGN KEY (
      --
    	id_usuario
      --
   ) REFERENCES usuario (
      --
    	id_usuario
      --
   )
);

-- LOG_JUSTIFICACION
CREATE TABLE log_justificacion (
   --
	id_log_justificacion	NUMBER(10)		NOT NULL		   ,
	id_justificacion		NUMBER(10)		NOT NULL		   ,
	id_usuario 				NUMBER(10)		NOT NULL		   ,
	accion					VARCHAR2(20)	NOT NULL		   ,
	fec_accion 				DATE DEFAULT SYSDATE NOT NULL	,
   --
	CONSTRAINT PK_LOG_JUSTIFICACION PRIMARY KEY (
      --
      id_log_justificacion
      --
   ),
   CONSTRAINT FK_LOGJ_JUSTIFICACION FOREIGN KEY (
      --
   	id_justificacion
      --
   ) REFERENCES justificacion (
   	--
      id_justificacion
      --
   ),
   CONSTRAINT FK_LOGJ_USUARIO FOREIGN KEY (
   	--
      id_usuario
      --
   ) REFERENCES usuario (
   	--
      id_usuario
      --
   )
);