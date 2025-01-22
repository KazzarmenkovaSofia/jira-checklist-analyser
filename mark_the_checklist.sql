drop table if exists dor_analisis;
create table dor_analisis as
  
SELECT задача, метки
,(regexp_matches(assignee, '''name'': ''([^'']+)'''))[1] as Исполнитель
,trim(both from substring(split_part(customfield_175100_3,',',2), '''checked'':([ ()0-9A-zА-я"-]+)'), '"') У_задачи_есть_явная_бизнес_ценность
,trim(both from substring(split_part(customfield_175100_4,',',2), '''checked'':([ ()0-9A-zА-я"-]+)'), '"') Есть_оценка_по_RICE
,trim(both from substring(split_part(customfield_175100_5,',',3), '''checked'':([ ()0-9A-zА-я"-]+)'), '"') Нет_внешних_блокировок
,trim(both from substring(split_part(customfield_175100_6,',',2), '''checked'':([ ()0-9A-zА-я"-]+)'), '"') Мы_уверены_что_у_нас_есть_все_для_выполнения_задачи
,trim(both from substring(split_part(customfield_175100_7,',',2), '''checked'':([ ()0-9A-zА-я"-]+)'), '"') Понятен_As_Is_и_To_Be
,trim(both from substring(split_part(customfield_175100_8,',',2), '''checked'':([ ()0-9A-zА-я"-]+)'), '"') Есть_понятные_критерии_приемки_заказчиком
,trim(both from substring(split_part(customfield_175100_9,',',2), '''checked'':([ ()0-9A-zА-я"-]+)'), '"') Пройдена_спецификация
,trim(both from substring(split_part(customfield_175100_11,',',5), '''checked'':([ ()0-9A-zА-я"-]+)'), '"') Задача_успешно_прошла_все_этапы
,trim(both from substring(split_part(customfield_175100_12,',',4), '''checked'':([ ()0-9A-zА-я"-]+)'), '"') Все_пункты_процедуры_соответствуют_чек_листу
,trim(both from substring(split_part(customfield_175100_13,',',2), '''checked'':([ ()0-9A-zА-я"-]+)'), '"') Заказчик_принял_работу
,trim(both from substring(split_part(customfield_175100_14,',',4), '''checked'':([ ()0-9A-zА-я"-]+)'), '"') Задача_соответствует_критериям_безопасности_компании
,trim(both from substring(split_part(customfield_175100_15,',',3), '''checked'':([ ()0-9A-zА-я"-]+)'), '"') Разработка_выполнена_с_учетом_стандартов
from kazarmenkova_checklist_analisis
where value_customfield_175100 IS NOT NULL;
SELECT * FROM dor_analisis
