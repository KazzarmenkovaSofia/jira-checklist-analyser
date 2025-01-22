# making new table for analize checklists

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

#indicate the veracity of the checkbox selection
  
SELECT задача, исполнитель,
CASE
WHEN метки LIKE('%product_launch_change%') OR метки LIKE('%sub_product_launch_change%')
THEN 'Запуски'
WHEN метки LIKE('%minor_change%') OR метки LIKE('%interface_process%') OR метки LIKE('%change_process%')
THEN 'Улучшения'
WHEN метки LIKE('%prometheus%') OR метки LIKE('%fix_process%') OR метки LIKE('%for_u_inform%')
THEN 'Гигиена'
ELSE 'Другое'
END AS kategoria,
У_задачи_есть_явная_бизнес_ценность
,Есть_оценка_по_RICE
,Нет_внешних_блокировок
,Мы_уверены_что_у_нас_есть_все_для_выполнения_задачи
,Понятен_As_Is_и_To_Be
,Есть_понятные_критерии_приемки_заказчиком
,Пройдена_спецификация
,Задача_успешно_прошла_все_этапы
,Все_пункты_процедуры_соответствуют_чек_листу
,Заказчик_принял_работу
,Задача_соответствует_критериям_безопасности_компании
,Разработка_выполнена_с_учетом_стандартов
,CASE
WHEN у_задачи_есть_явная_бизнес_ценность=' True'
AND Есть_оценка_по_RICE=' True'
AND Нет_внешних_блокировок=' True'
AND Мы_уверены_что_у_нас_есть_все_для_выполнения_задачи=' True'
AND Понятен_As_Is_и_To_Be=' True'
AND Есть_понятные_критерии_приемки_заказчиком=' True'
AND Пройдена_спецификация=' True'
AND Заказчик_принял_работу=' True'
AND Задача_соответствует_критериям_безопасности_компании=' True'
AND Разработка_выполнена_с_учетом_стандартов=' True'
THEN 'True'
ELSE 'False'
END AS mur
from dor_analisis;

#adding points

drop table if exists dor_analisis_mur;
create table dor_analisis_mur as
SELECT задача, исполнитель,
CASE
WHEN метки LIKE('%minor_change%') OR метки LIKE('%interface_process%') OR метки LIKE('%change_process%')
THEN 'True'
ELSE 'False'
END AS top_check,
CASE
WHEN метки LIKE('%product_launch_change%') OR метки LIKE('%sub_product_launch_change%')
THEN 'Запуски'
WHEN метки LIKE('%minor_change%') OR метки LIKE('%interface_process%') OR метки LIKE('%change_process%')
THEN 'Улучшения'
WHEN метки LIKE('%prometheus%') OR метки LIKE('%fix_process%') OR метки LIKE('%for_u_inform%')
THEN 'Гигиена'
ELSE 'Другое'
END AS kategoria,
У_задачи_есть_явная_бизнес_ценность
,Есть_оценка_по_RICE
,Нет_внешних_блокировок
,Мы_уверены_что_у_нас_есть_все_для_выполнения_задачи
,Понятен_As_Is_и_To_Be
,Есть_понятные_критерии_приемки_заказчиком
,Пройдена_спецификация
,Задача_успешно_прошла_все_этапы
,Все_пункты_процедуры_соответствуют_чек_листу
,Заказчик_принял_работу
,Задача_соответствует_критериям_безопасности_компании
,Разработка_выполнена_с_учетом_стандартов
,CASE
WHEN у_задачи_есть_явная_бизнес_ценность=' True'
THEN 0
ELSE 1
END AS у_задачи_есть_явная_бизнес_ценность_mur
,CASE
WHEN Есть_оценка_по_RICE=' True'
THEN 0
ELSE 1
END AS Есть_оценка_по_RICE_mur
,CASE 
WHEN Нет_внешних_блокировок=' True'
THEN 0
ELSE 1
END AS Нет_внешних_блокировок_mur
,CASE 
WHEN Мы_уверены_что_у_нас_есть_все_для_выполнения_задачи=' True'
THEN 0
ELSE 1
END AS Мы_уверены_что_у_нас_есть_все_для_выполнения_задачи_mur
,CASE 
WHEN Понятен_As_Is_и_To_Be=' True'
THEN 0
ELSE 1
END AS Понятен_As_Is_и_To_Be_mur
,CASE 
WHEN Есть_понятные_критерии_приемки_заказчиком=' True'
THEN 0
ELSE 1
END AS Есть_понятные_критерии_приемки_заказчиком_mur
,CASE 
WHEN Пройдена_спецификация=' True'
THEN 0
ELSE 1
END AS Пройдена_спецификация_mur
,CASE 
WHEN Заказчик_принял_работу=' True'
THEN 0
ELSE 1
END AS Заказчик_принял_работу_mur
,CASE 
WHEN Задача_соответствует_критериям_безопасности_компании=' True'
THEN 0
ELSE 1
END AS Задача_соответствует_критериям_безопасности_компании_mur
,CASE 
WHEN Разработка_выполнена_с_учетом_стандартов=' True'
THEN 0
ELSE 1
END AS Разработка_выполнена_с_учетом_стандартов_mur
from dor_analisis;

# counting results

SELECT задача, исполнитель,
top_check,
kategoria,
У_задачи_есть_явная_бизнес_ценность,
Есть_оценка_по_RICE
,Нет_внешних_блокировок
,Мы_уверены_что_у_нас_есть_все_для_выполнения_задачи
,Понятен_As_Is_и_To_Be
,Есть_понятные_критерии_приемки_заказчиком
,Пройдена_спецификация
,Задача_успешно_прошла_все_этапы
,Все_пункты_процедуры_соответствуют_чек_листу
,Заказчик_принял_работу
,Задача_соответствует_критериям_безопасности_компании
,Разработка_выполнена_с_учетом_стандартов,
(у_задачи_есть_явная_бизнес_ценность_mur 
+ Есть_оценка_по_RICE_mur 
+ Нет_внешних_блокировок_mur 
+ Мы_уверены_что_у_нас_есть_все_для_выполнения_задачи_mur
+ Понятен_As_Is_и_To_Be_mur
+ Есть_понятные_критерии_приемки_заказчиком_mur
+ Пройдена_спецификация_mur
+ Заказчик_принял_работу_mur
+ Задача_соответствует_критериям_безопасности_компании_mur
+ Разработка_выполнена_с_учетом_стандартов_mur)*100/10 as perc_mur
from dor_analisis_mur
