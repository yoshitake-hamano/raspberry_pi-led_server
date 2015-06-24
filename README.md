# raspberry_pi-led_server
Ruby WEBrick led server.

# 概要

Ruby WEBrickを使用してLEDチカチカをTCP/IPから制御します。

# 準備

## 回路図

以下の回路図のように組み立ててください。

![raspberrypi led schematic](images/raspberrypi_led_schematic.png)

## OSインストール後、1回だけ実施

GPIOを操作するには、Root権限もしくはGPIO権限が必要となります。
この例では、デフォルトユーザであるpiをGPIOグループに所属させることで上記を満たします。

````.bash
$ sudo chmod -aG gpio pi
$ sudo apt-get install ruby git
````

# 実行

````.bash
$ git clone git@github.com:yoshitake-hamano/raspberrypi_led_server.git
$ cd raspberrypi_led_server
$ ./led_server.rb
````

# LED制御

Raspberry PiのIPアドレスを[Rasp Addr]とすると以下のようにすることでLEDをON/OFFすることが可能です。
HTTPプロトコルのGETを使用しているだけなので、ブラウザからアクセスするだけで制御出来ます。

````.bash
$ wget http://[Rasp Addr]/on
$ wget http://[Rasp Addr]/off
````
