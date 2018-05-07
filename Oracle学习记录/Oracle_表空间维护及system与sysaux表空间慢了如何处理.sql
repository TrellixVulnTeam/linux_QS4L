��ռ�ά��-״̬���

������ͼ��
�鿴��ռ���Ϣ
dba_tablespaces;
v$tablespace;

�鿴�����ļ�
dba_data_files;
v$datafile;

��ʱ�ļ���Ϣ
dba_temp_files;
v$tempfile

Oracle DBA�ճ�ά�������ֲ������ܽ�
�ο���ַ��http://www.itpux.com/thread-218-1-1.html

��ѯ��ռ�״̬��
select tablespace_name,status from dba_tablespaces;

��ѯ��ռ��������ļ���Ӧ��ϵ��
select tablespace_name,bytes, file_name from dba_data_files;

��ѯ�û�ȱʡ��ռ䣺
select username,default_tablespace from dba_users;
select username,default_tablespace from dba_users where username='ITPUX';

��ѯ����洢�ñ�ı�ռ䣺
select table_name,tablespace_name from dba_tables;
select table_name,tablespace_name from dba_tables where owner='ITPUX';

�޸��û�ȱʡ��ռ䣺
alter user itpux default tablespace itpux08;

�����ݴ�һ����ռ��ƶ�������һ����ռ䣺
alter table table_name move tablespace tablespace_name;

��ѯ��ռ�״̬
-- ��ѯ��� STATUSΪ ONLINE ��ʾΪ����״̬�����������ΪOFFLINE��˵����ռ䲻���ã�RECOVER��Ҫ�ָ�
col tablespace_name for a15
select tablespace_name,block_size,status,contents,logging from dba_tablespaces;

��ѯ�����ļ�·��
select file_id,file_name,tablespace_name,status,bytes from dba_data_files;
ORA-01653��unable to extend table itpuxtbs by 128 in tablespace ITPUX01

�������ű�������ʹ��
1��
col f.tablespace_name format a15
col d.tot_grootte_mb format a10
col ts-per format a8

select upper(f.tablespace_name) "TS-name",
       d.tot_grootte_mb "TS-bytes(m)",
       d.tot_grootte_mb - f.total_bytes "TS-used(m)",
       f.total_bytes "TS-free(m)",
       to_char(round((d.tot_grootte_mb - f.total_bytes) / d.tot_grootte_mb * 100,
                     2),
               '990.99') "TS-per"
from (select tablespace_name,
             round(sum(bytes) / (1024 * 1024),2) total_bytes,
             round(max(bytes) / (1024 * 1024),2) max_bytes
             from sys.dba_free_space
             group by tablespace_name) f,
             (select dd.tablespace_name,
                     round(sum(dd.bytes) / (1024*1024),2) tot_grootte_mb
              from sys.dba_data_files dd
              group by dd.tablespace_name) d
where d.tablespace_name = f.tablespace_name
order by 5 desc;

2��
set line 200
select D.TABLESPACE_NAME,
       SPACE "SUM_SPACE(M)",
       BLOCKS SUM_BLOCKS,
       SPACE - NVL(FREE_SPACE, 0) "USED_SPACE(M)",
       ROUND((1-NVL(FREE_SPACE, 0) / SPACE) * 100, 2) "USED_RATE(%)",
       FREE_SPACE "FREE_SPACE(M)"
   FROM (SELECT TABLESPACE_NAME,
                ROUND(SUM(BYTES) / (1024 * 1024), 2) SPACE,
                SUM(BLOCKS) BLOCKS
         FROM DBA_DATA_FILES
         GROUP BY TABLESPACE_NAME) D,
        (SELECT TABLESPACE_NAME,
                ROUND(SUM(BYTES) / (1024 * 1024), 2) FREE_SPACE
         FROM DBA_FREE_SPACE
         GROUP BY TABLESPACE_NAME) F
   WHERE D.TABLESPACE_NAME = F.TABLESPACE_NAME(+)      
   UNION ALL -- if have tempfile
   SELECT D.TABLESPACE_NAME,
          SPACE "SUM_SPACE(M)",
          BLOCKS SUM_BLOCKS,
          USED_SPACE "USED_SPACE(M)",
          ROUND(NVL(USED_SPACE, 0) / SPACE * 100, 2) "USED_RATE(%)",
          NVL(FREE_SPACE, 0) "FREE_SPACE(M)"
   FROM (SELECT TABLESPACE_NAME,
                ROUND(SUM(BYTES) / (1024 * 1024), 2) SPACE,
                SUM(BLOCKS) BLOCKS
         FROM DBA_TEMP_FILES
         GROUP BY TABLESPACE_NAME) D,
         (SELECT TABLESPACE_NAME,
                  ROUND(SUM(BYTES_USED) / (1024 * 1024), 2) USED_SPACE,
                  ROUND(SUM(BYTES_FREE) / (1024 * 1024), 2) FREE_SPACE
           FROM V$TEMP_SPACE_HEADER
           GROUP BY TABLESPACE_NAME) F
WHERE D.TABLESPACE_NAME = F.TABLESPACE_NAME(+)
ORDER BY 5 DESC;


Oracle ������ļ�(OMF)

show parameter db_create_file_dest;
show parameter db_create
show parameter db_recover

-- create tablespace itpux09 datafile '/oracle/app/oracle/oradata/db01/ITPUX09_01.DBF' SIZE 2M  AUTOEXTEND OFF  BLOCKSIZE 32K;
create tablespace itpux09 datafile '/oracle/app/oracle/oradata/db01/' SIZE 2M  AUTOEXTEND OFF  BLOCKSIZE 32K;

alter system set db_recovery_file_dest_size = 5G;
alter system set db_recovery_file_dest='/oracle/app/oracle/db_recovery' scope=both;

alter system set db_create_file_dest='/oracle';
create tablespace itpux10 ;
create tablespace itpux11 datafile size 2m;
-- drop tablespace itpux10 including contents and datafiles;
select name from v$datafile;


SYSTEM  �� SYSAUX ��ռ�������ô�죿
-- ��չ��ռ�
-- ��������
system

sysaux
-- 1������sys��system�û��������Ƿ����system��ռ�
select * from dba_segments where tablespace_name='SYSTEM' and owner not in('SYS','SYSTEM');

-- 2�������û�OUTLN������
-- 3����ѯռ�������ռ����Ķ���
-- all 
select bytes/1024/1024 AS "SIZE_MB", segment_name,segment_type,owner from dba_segments 
where tablespace_name='SYSTEM' order by SIZE_MB desc ;
                     
-- top 10

select * from (
       select bytes/1024/1024 AS "SIZE_MB", segment_name,segment_type,owner from dba_segments 
       where tablespace_name='SYSTEM' order by SIZE_MB desc)
where rownum < 11;

-- 4���鵽����ΪIDL_UB1$��ռ��240M
cd $ORACLE_HOME
/oracle/app/oracle/product/11.2.0
find ./ -name sql.bsq
tail -5 ./rdbms/admin/sql.bsq 
/*
dtools.bsq
dexttab.bsq
ddm.bsq
dlmnr.bsq
ddst.bsq
*/
-- ./rdbms/admin/sql.bsq
vim   ./rdbms/admin/dplsql.bsq
create table idl_ub1$                            /* idl table for ub1 pieces */
( obj#          number not null,                            /* object number */
  part          number not null,
         /* part: 0 = diana, 1 = portable pcode, 2 = machine-dependent pcode */
  version       number,                                    /* version number */
  piece#        number not null,                             /* piece number */
  length        number not null,                             /* piece length */
  piece         long raw not null)                              /* ub1 piece */
  storage (initial 10k next 100k maxextents unlimited pctincrease 0)
/

-- 5. alter tablespace
alter tablespace system add datafile '/oracle/app/oracle/oradata/db01/sysaux02.dbf' size 100m autoextend off;


--       ��������
sysaux

-- 1������sys��system�û��������Ƿ����system��ռ�
select * from dba_segments where tablespace_name='SYSAUX' and owner not in('SYS','SYSTEM');

-- 2����ѯռ�������ռ����Ķ���
-- all 
select bytes/1024/1024 AS "SIZE_MB", segment_name,segment_type,owner from dba_segments 
where tablespace_name='SYSAUX' order by SIZE_MB desc ;
                     
-- top 10

select * from (
       select bytes/1024/1024 AS "SIZE_MB", segment_name,segment_type,owner from dba_segments 
       where tablespace_name='SYSAUX' order by SIZE_MB desc)
where rownum < 11;

-- 3����ѯ���ֶζ���
select * from dba_lobs where segment_name='SYS_LOB0000056506C00025$$';

select * from dba_lobs where segment_name='SYS_LOB00000+56506+C000+25+$$';
select * from dba_objects where object_id='56506';

select * from dba_segments where tablespace_name='SYSAUX' and segment_name like '%MNR%';
select * from v$sysaux_occupants where occupant_name='LOGMNR';
     
-- �ƶ�
exec sys.dbms_logmnr_d.set_tablespace('USERS');
SQL> exec sys.dbms_logmnr_d.set_tablespace('USERS');

PL/SQL procedure successfully completed.
                     
-- 4����֤
select * from dba_segments where tablespace_name='SYSAUX'  and  segment_name like '%MNR%';
select * from v$sysaux_occupants where occupant_name='LOGMNR';
select * from dba_segments where tablespace_name='USERS' and segment_name like '%MNR%';

-- 5����ԭ
exec sys.dbms_logmnr_d.set_tablespace('SYSAUX');
