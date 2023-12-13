PET-проект.
Приложение, позволяющее посчитать цену за кг/л/штуки какого-либо продукта.
Сканируя штрих-код товара, получает его название, из названия парсит количество единиц продукта и тип единиц (граммы/килограммы/миллилитры/литры/штуки).
Дальнейшее направление развития:
1) Отрефакторить код (есть повторяющиеся места, что не очень хорошо)
2) Доработать графический дизайн
3) Поработать с констрейнтами (чтобы приложение нормально запускалось на любом телефоне)
4) Доработать список товаров:
   a) размещать не все товары в одной секции, а сделать три секции - весовые, 'объемные' и штучные товары
   b) добавить сортировку по цене
   c) исключить добавление товаров с одним и тем же именем
5) Доработать хранилище данных - хранить список товаров не в UserDefaults, а в CoreData
6) Сделать доступной тёмную тему
7) Сделать доступными другие ориентации устройства, помимо портретной
