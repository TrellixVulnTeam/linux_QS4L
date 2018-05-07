/* ��ռ���ճ�������ά������-��ռ������Ǩ�� */
-- ����һ�����ߴ���
/*
���裺
1����ѯ��ǰ��ռ�������ļ���״̬
2��ʹ��ռ�offline
3���ƶ������ļ�
4��alter tablespace ��ռ������������ļ�
5��ʹ��ռ�online
6����ѯ��ǰ��ռ�������ļ���״̬
*/
-- 1����ѯĿǰ�ı�ռ����ƺͶ�Ӧ���ļ�����
-- select tablespace_name,file_name from dba_data_files;
SELECT tablespace_name,file_name,online_status FROM dba_data_files WHERE tablespace_name='IT2';

/* ִ�н������ 
1	IT2	/oracle/app/oracle/oradata/db01/itp201.dbf
*/

-- 2 ����ռ�����
ALTER tablespace it2 offline;
SELECT tablespace_name,file_name,online_status FROM dba_data_files WHERE tablespace_name='IT2';

-- 3�������ļ���Ŀ��λ��,������ϵͳ���� oracle�û�����
cp /oracle/app/oracle/oradata/db01/itp201.dbf /oracle/app/oracle/oradata/db01/it201.dbf

-- 4���޸ı�ռ��Ӧ���ļ�����
ALTER TABLESPACE it2 rename datafile '/oracle/app/oracle/oradata/db01/itp201.dbf' to '/oracle/app/oracle/oradata/db01/it201.dbf';

-- 5����ռ�����
ALTER tablespace it2 online;
SELECT tablespace_name,file_name,online_status FROM dba_data_files WHERE tablespace_name='IT2';

-- ��ע���������ɾ����ԭ�����ļ�(����һ��ʼʹ��mv)


-- �����������ߴ���
/*
���裺
1���ر����ݿ⣬������mount״̬
2���ƶ����ļ�
3��ͨ��alter database�������ļ�
4�������ݿ�
5�����״̬
*/
-- 1��
shutdown immediate;
startup mount;

-- 2���ƶ��ļ�,������ϵͳ���� oracle�û�����
cp /oracle/app/oracle/oradata/db01/it201.dbf /oracle/app/oracle/oradata/db01/it2_1.dbf

-- 3��ͨ��alter datafile�������ļ�

ALTER DATABASE rename file '/oracle/app/oracle/oradata/db01/it201.dbf'to '/oracle/app/oracle/oradata/db01/it2_1.dbf';

-- 4�������ݿ�
alter database open;

-- 5�����״̬
SELECT tablespace_name,file_name,online_status FROM dba_data_files WHERE tablespace_name='IT2';









