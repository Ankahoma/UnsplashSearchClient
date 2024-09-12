# UnsplashSearchClient
Тестовое задание на позицию iOS-разработчика-интерна в Avito

* [Установка](#установка)
* [О приложении](#о-приложении)
* [Функционал](#функционал)
* [Экран поиска изображений](#экран-поиска-изображений)
* [Экран Галереи приложения](#экран-галереи-приложения)
* [Экран просмотра изображения](#экран-просмотра-изображения)
* [Поддержка тёмной и светлой темы в приложении](#поддержка-тёмной-и-светлой-темы-в-приложении)
* [Демонстрация работы приложения](#демонстрация-работы-приложения)

## Установка
Открыть проект в XCode, запустить на устройстве либо в симуляторе.\
Минимальная версия iOS - 16.0


# О приложении
Хранение изображений: CoreData, экспорт в галерею телефона\
Хранение истории запросов: UserDefaults\
Работа с сетью: URLSession\
Архитектура: VIPER

## Функционал:
Сообщения об ошибках\
Пагинация\
Загрузка изображений в бэкграунде

### Экран поиска изображений
История запросов: 
* до 5 последних в предложении вариантов при поиске\
![IMG_1320](https://github.com/user-attachments/assets/34d4f240-f74f-4c3c-a107-a52c77234f50)

В каждой ячейке есть панель с информацией о размере изображения.\
Доступно два формата отображения результатов поиска: плитка в две колонки и плитка в одну колонку.\
Смена режима осуществляется кнопкой на панели навигации. Иконка кнопки меняется в зависимости от выбранного формата.\
![IMG_1321](https://github.com/user-attachments/assets/86848f6e-357f-476f-b170-a08036d946ad) ![IMG_1322](https://github.com/user-attachments/assets/58851f89-0438-4ebd-b4fd-ef08cfab51a2)

При тапе на изображение в любой ячейке показвается меню с двумя кнопками -- Download и Preview\
![IMG_1323](https://github.com/user-attachments/assets/bad965f2-d251-4f9e-bb60-8590b212e75e)

Preview: открывается модальный экран с превью изображения и краткой информацией: описание изображения (если имеется), автор (если указан), дата создания (дата загрузки на сервер)\
![IMG_1324](https://github.com/user-attachments/assets/c4ed5ccc-eb04-402b-9198-41b547019e27)

Download: начинается загрузка -- в ячейке появляется панель управления загрузкой с индикацией прогресса и возможностью приостановить, возобновить или отменить загрузку.\
Можно загружать несколько изображений одновременно. Загрузка осуществляется в бэкграунде.\
![IMG_1327](https://github.com/user-attachments/assets/7e68b149-1b49-4514-97d9-086477f4c928)

При завершении загрузки в ячейке появляется иконка галереи с чекмарком -- изображение сохранено в Галерею приложения.\
Переход на экран Галереии осуществляется нажатием правой кнопки навигационной панели.\
![IMG_1330](https://github.com/user-attachments/assets/9815589d-e44a-4ef5-bed6-590d25561e3a)

### Экран Галереи приложения
Изображения сортируются по совершённым пользователем запросам.\
![IMG_682B0C4AF509-1](https://github.com/user-attachments/assets/c703e288-0807-41a5-8dfd-23b4e62e8f1a)

Опция выбора изображений (кнопка Select, отмена выбора -- кнопка Cancel) и удаления одного или нескольких изображений из хранилища приложения.\
![IMG_1328](https://github.com/user-attachments/assets/408c9a6c-cff6-4171-bf1c-ab8f9027c12c)

При нажатии на изображение открывается модальный экран просмотра изображения и информациии о нём (описание (если имеется), автор (если указан) , дата создания (дата загрузки на сервер)).\
![IMG_4782EE485BC6-1](https://github.com/user-attachments/assets/3915cd85-9ced-4149-ace1-c1063293d2c4)

### Экран просмотра изображения 
Изображения и информациии о нём (описание, автор, дата создания).\
Опция сохранения в Галерею приложения, в том числе экспорт в галерею телефона\
(стандартное меню iOS с опциями в зависимости от установленных приложений мессенджеров и пр.)\
![IMG_1329](https://github.com/user-attachments/assets/e4b99955-0e7f-4d26-8d52-bd435a47f1d4)


### Поддержка тёмной и светлой темы в приложении
![IMG_1331](https://github.com/user-attachments/assets/cea98037-3bcd-4c3f-81ea-814898a19b15) ![IMG_1330](https://github.com/user-attachments/assets/62ff6fd0-f15f-4682-b5c4-dc15a8d78350)



## Демонстрация работы приложения

![OutputSmall](https://github.com/user-attachments/assets/e1986759-14b2-466c-9d9e-cff80a595331)\
![OutputSmall 3](https://github.com/user-attachments/assets/b75f0cb3-e931-4584-87a5-f5e80c6637b1)\
![OutputSmall 2](https://github.com/user-attachments/assets/df83fb0d-7629-417b-a68e-cb8452a5ab2f)


