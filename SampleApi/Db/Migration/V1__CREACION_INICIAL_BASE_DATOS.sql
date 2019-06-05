/*==============================================================*/
/* Table: comuna                                                */
/*==============================================================*/
create table Comuna (
   IdComuna            int4                 not null,
   IdProvincia         int4                 null,
   Nombre               varchar(100)         not null,
   constraint pk_Comuna primary key (IdComuna)
);

/*==============================================================*/
/* Table: PerfilUsuario                                        */
/*==============================================================*/
create table PerfilUsuario (
   IdPerfilUsuario    int4                 not null,
   Nombre               varchar(100)         not null,
   constraint pk_PerfilUsuario primary key (IdPerfilUsuario)
);

/*==============================================================*/
/* Table: Persona                                               */
/*==============================================================*/
create table Persona (
   IdPersona           bigserial            not null,
   IdComuna            int4                 null,
   Run                  int4                 null,
   Nombres              varchar(255)         not null,
   ApellidoPaterno      varchar(255)         not null,
   ApellidoMaterno      varchar(255)         null,
   FechaNacimiento      date                 null,
   Telefono             varchar(20)          null,
   Email                varchar(100)         not null,
   constraint pk_Persona primary key (IdPersona)
);

/*==============================================================*/
/* Index: idx_PersonaEmail                                     */
/*==============================================================*/
create unique index idx_PersonaEmail on Persona (
Email
);

/*==============================================================*/
/* Index: idx_PersonaRun                                       */
/*==============================================================*/
create unique index idx_PersonaRun on Persona (
Run
);


/*==============================================================*/
/* Table: Provincia                                             */
/*==============================================================*/
create table Provincia (
   IdProvincia         int4                 not null,
   IdRegion            int4                 null,
   Nombre               varchar(100)         not null,
   constraint pk_Provincia primary key (IdProvincia)
);

/*==============================================================*/
/* Table: Region                                                */
/*==============================================================*/
create table Region (
   IdRegion            int4                 not null,
   Nombre               varchar(100)         not null,
   constraint pk_Region primary key (IdRegion)
);

/*==============================================================*/
/* Table: Usuario                                               */
/*==============================================================*/
create table Usuario (
   IdPersona           int8                 not null,
   IdPerfilUsuario    int4                 not null,
   Username             varchar(255)         not null,
   Password             varchar(500)         null,
   Habilitado           boolean              not null,
   constraint pk_Usuario primary key (IdPersona)
);

/*==============================================================*/
/* Index: idx_UsuarioUsername                                  */
/*==============================================================*/
create unique index idx_UsuarioUsername on Usuario (
Username
);

alter table Comuna
   add constraint fk_ComunaReferenceProvincia foreign key (IdProvincia)
      references Provincia (IdProvincia)
      on delete restrict on update restrict;

alter table Provincia
   add constraint fk_ProvinciaReferenceRegion foreign key (IdRegion)
      references Region (IdRegion)
      on delete restrict on update restrict;

alter table Usuario
   add constraint fk_UsuarioReferencePersona foreign key (IdPersona)
      references Persona (IdPersona)
      on delete restrict on update restrict;

alter table Usuario
   add constraint fk_UsuarioReferencePerfilUsuario foreign key (IdPerfilUsuario)
      references PerfilUsuario (IdPerfilUsuario)
      on delete restrict on update restrict;

alter table Persona
   add constraint fk_PersonaReferenceComuna foreign key (IdComuna)
      references Comuna (IdComuna)
      on delete restrict on update restrict;