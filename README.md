Тестовое задание ToDoList

Требования:
1. Список задач:
- Отображение списка задач на главном экране.
- Задача должна содержать название, описание, дату создания и статус (выполнена/не
выполнена).
- Возможность добавления новой задачи.
- Возможность редактирования существующей задачи.
- Возможность удаления задачи.
- Возможность поиска по задачам.
2. Загрузка списка задач из dummyjson api: https://dummyjson.com/todos. При первом
запуске приложение должно загрузить список задач из указанного json api.
3. Многопоточность:
- Обработка создания, загрузки, редактирования, удаления и поиска задач должна
выполняться в фоновом потоке с использованием GCD или NSOperation.
- Интерфейс не должен блокироваться при выполнении операций.
4. CoreData:
- Данные о задачах должны сохраняться в CoreData.
- Приложение должно корректно восстанавливать данные при повторном запуске.
5. Используйте систему контроля версий GIT для разработки.
6. Архитектура VIPER: Приложение должно быть построено с использованием
архитектуры VIPER. Каждый модуль должен быть четко разделен на компоненты: View,
Interactor, Presenter, Entity, Router.

Реализован весь требуемый функционал, реализована архитектруа VIPER.
Обработка задач реализована на фоном потоке с использованием GCD
