CREATE USER 'frigolog_dat_acqu_ino'@'%' IDENTIFIED BY 'datAcquInoFrigo123';
GRANT INSERT ON frigolog.leitura TO 'frigolog_dat_acqu_ino'@'%';

CREATE USER 'frigolog_web_data_viz'@'%' IDENTIFIED BY 'webDataVizFrigo123';
GRANT SELECT, INSERT, UPDATE, DELETE ON frigolog.* TO 'frigolog_web_data_viz'@'%';

CREATE USER 'felipeSantos_frigolog'@'%' IDENTIFIED BY 'felipeSantosFrigo123';
CREATE USER 'thaysRamos_frigolog'@'%' IDENTIFIED BY 'thaysRamosFrigo123';
CREATE USER 'matheusTavares_frigolog'@'%' IDENTIFIED BY 'matheusTavaresFrigo123';
CREATE USER 'brunoRafael_frigolog'@'%' IDENTIFIED BY 'brunoRafaelFrigo123';
CREATE USER 'matheusDelfiol_frigolog'@'%' IDENTIFIED BY 'matheusDelfiolFrigo123';
CREATE USER 'luizPhelipe_frigolog'@'%' IDENTIFIED BY 'luizPhelipeFrigo123';

GRANT ALL PRIVILEGES ON frigolog.* TO 'felipeSantos_frigolog'@'%';
GRANT ALL PRIVILEGES ON frigolog.* TO 'thaysRamos_frigolog'@'%';
GRANT ALL PRIVILEGES ON frigolog.* TO 'matheusTavares_frigolog'@'%';
GRANT ALL PRIVILEGES ON frigolog.* TO 'brunoRafael_frigolog'@'%';
GRANT ALL PRIVILEGES ON frigolog.* TO 'matheusDelfiol_frigolog'@'%';
GRANT ALL PRIVILEGES ON frigolog.* TO 'luizPhelipe_frigolog'@'%';

FLUSH PRIVILEGES;