-- �ƶ������󵽱�ı�ռ�
a�������Ϣ��״̬
b���ƶ�����(��������)������һ����ռ�
c�������Ϣ
d��ͨ���ؽ������ķ����ƶ�����
e���ٴμ��ȷ��

-- 1�������Ϣ��״̬
-- �鿴��ռ���Ϣ
select * from dba_tablespaces;
select * from v$tablespace;

-- �鿴�����ļ�
select * from dba_data_files where tablespace_name='IT2';
select * from v$datafile;
select name,bytes/1024/1024 from v$datafile;

-- 2���ƶ���������һ����ռ�
-- Ŀ���ǰѱ�ռ�IT2��itpux�û��µı�table01Ǩ�Ƶ���ռ�ITPUX08


-- Ǩ��ǰ��ѯ
-- table01��idx_table01_id
-- tbs: IT2 
select * from dba_segments where owner='ITPUX' and segment_name IN ('table01','IDX_TABLE01_ID');


-- type��index and table
select * from dba_objects where owner='ITPUX' and object_name IN ('table01','IDX_TABLE01_ID');
select * from dba_indexes where owner='ITPUX' and index_name='IDX_TABLE01_ID';

create table itpux.table01(id number(12),c_date date);
insert into itpux.table01 values(1,sysdate);
insert into itpux.table01 values(2,sysdate);
insert into itpux.table01 values(3,sysdate);
insert into itpux.table01 values(4,sysdate);
insert into itpux.table01 values(5,sysdate);

create index idx_table01_id on itpux.table01('id');
commit;

-- 3�������Ϣ
select * from dba_segments where owner='ITPUX' and segment_name IN ('table01','IDX_TABLE01_ID');
select * from dba_objects where owner='ITPUX' and object_name IN ('table01','IDX_TABLE01_ID');
select * from dba_indexes where owner='ITPUX' and index_name='IDX_TABLE01_ID';

-- 4��ͨ���ؽ������ķ����ƶ�����
alter table itpux.table01 move tablespace itpux08;
alter index itpux.idx_table01_id rebuild tablespace itpux08;

-- 5��Ǩ�ƺ��ѯ
select * from dba_segments where owner='ITPUX' and segment_name IN ('table01','IDX_TABLE01_ID');
select * from dba_objects where owner='ITPUX' and object_name IN ('table01','IDX_TABLE01_ID');
select * from dba_indexes where owner='ITPUX' and index_name='IDX_TABLE01_ID';

-- 6������д��ֶ� lob
alter table itpux.table01 move lob(date) store as (tablespace itpux08);

