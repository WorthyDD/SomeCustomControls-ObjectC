from PIL import Image

image = Image.open('test.jpg')

image.thumbnail((1024,1024))
image.save('1024.jpg')
image.thumbnail((180,180))
image.save('180.png')
image.thumbnail((120,120))
image.save('120.png')
image.thumbnail((87,87))
image.save('87.png')
image.thumbnail((80,80))
image.save('80.png')
image.thumbnail((58,58))
image.save('58.png')
image.thumbnail((40,40))
image.save('40.png')