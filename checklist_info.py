import requests
from requests.auth import HTTPBasicAuth
import json
import pandas as pd


jira_url = 'https://jira.link'
username = MY_USER_NAME
token = MY_PASSWORD
project_key = ['KEY1,'KEY2','KEY3']

# Настройка параметров запроса для поиска задач по проекту
query = {
    'jql': f'project IN ({", ".join(project_key)})',
    'fields': 'summary,customfield_175100,labels',  # Укажите нужные поля
    'maxResults': 5000  # Максимальное количество результатов (можно увеличить)
}

issues = []  # Список для хранения задач

# Пагинация
start_at = 0
while True:
    query['startAt'] = start_at
    response = requests.get(jira_url, auth=HTTPBasicAuth(username, token), params=query)

    if response.status_code == 200:
        issues_data = response.json()
        if not issues_data.get('issues'):
            break  # выход из цикла, если нет больше задач

        for issue in issues_data.get('issues', []):
            issue_key = issue.get('key')
            custom_field_value = issue.get('fields', {}).get('customfield_175100', '')
            summary = issue.get('fields', {}).get('summary')
            labels = issue.get('fields', {}).get('labels', [])
            # Обработка поля custom_field_value
            if isinstance(custom_field_value, str):  # Если это строка
                try:
                    custom_field_json = json.loads(custom_field_value)  # Попробуйте разобрать его
                    custom_field_data = ', '.join(map(str, custom_field_json))  # Преобразование в строку
                except json.JSONDecodeError:
                    custom_field_data = 'Invalid JSON'
            elif isinstance(custom_field_value, list):  # Если это список
                custom_field_data = ', '.join(map(str, custom_field_value))  # Преобразуем список в строку
            else:
                custom_field_data = 'No data'  # Для других типов данных или отсутствия данных

            issues.append({
                'Задача': issue_key,
                'Название': summary,
                'Value_customfield_175100': custom_field_data,
                'Метки': ', '.join(labels)  # Преобразуем список меток в строку
        })

        start_at += query['maxResults']  # Увеличиваем стартовый индекс для следующей итерации
    else:
        print(f'Ошибка: {response.status_code} - {response.text}')
        break  # Если произошла ошибка, выходим из цикла

# Преобразуем список задач в DataFrame
df = pd.DataFrame(issues)

# Проверяем, есть ли данные в DataFrame
if df.empty:
    print("DataFrame пустой. Убедитесь, что запрос возвращает данные.")
else:
    # Разбиваем значение customfield_175100 на отдельные столбцы (если это нужно)
    custom_field_split = df['Value_customfield_175100'].str.split('{', expand=True)
    custom_field_split.columns = [f'customfield_175100_{i+1}' for i in range(custom_field_split.shape[1])]

    # Объединяем DataFrame с разбитыми столбцами
    df = pd.concat([df, custom_field_split], axis=1)
    # Сохраняем DataFrame в CSV файл
    tf.df_to_gp(df, 'kazarmenkova_checklist_analisis', gp_service = 'gp')
    # Вывод таблицы
    print(df)
