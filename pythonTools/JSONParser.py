# -*- coding:utf-8 -*-
import Tkinter
import re
from Tkinter import *


class App:
    def __init__(self, master):
        top = master
        top.geometry('600x1000')
        self.label = Tkinter.Label(top, text='paste json text here!')
        self.label.grid(row=0, columnspan=3)
        self.text = Text(top, bg='gray')
        self.text.grid(row=1, columnspan=3)
        self.btn1 = Button(top, text='property', command=self.clickBtn1)
        self.btn1.grid(row=2, column=0)
        self.btn2 = Button(top, text='dictionary', command=self.clickBtn2)
        self.btn2.grid(row=2, column=1)
        self.btn3 = Button(top, text = 'clear', command = self.clickBtn3)
        self.btn3.grid(row = 2, column = 2)
        self.result = Text(top)
        self.result.grid(row = 3, columnspan = 3)
        self.property = []
        self.jsonMap = []
        self.keys = []

    def clickBtn1(self):
        print 'click button1'
        self.result.delete('1.0', END)
        page = self.text.get('1.0', END)
        print page
        self.property = []
        self.jsonMap = []
        self.keys = []
        name = ''
        #字符串
        pattern1 = re.compile(r'"(.*?)" *: *"(.*?)"')
        items = re.findall(pattern1, page)
        for item in items:

            if item[0].find('_') < 0:
                #self.property.append([item[0]])
                if item[0] == 'id':
                    name1 = 'identifier'
                else:
                    name = item[0]
            else:
                names = item[0].split('_')
                n1 = names[0]
                for i in range(1, len(names)):
                    part = names[i]
                    n1 = n1+part[0].upper()+part[1:]
                name = n1
                #self.property.append(n1+n2)
            pro = '@property (nonatomic) NSString *' + name + ';'
            map = '@"'+item[0]+'" : @"'+name+'",'
            key = '@"'+item[0]+'",'
            self.property.append(pro)
            self.jsonMap.append(map)
            self.keys.append(key)
            print name
        '''
        # 数组
        pattern2 = re.compile(r"\"(.+?)\" *: *([[\s\S]*])")
        items = re.findall(pattern2, page)
        for item in items:

            print item[0]
            if item[0].find('_') < 0:
                # self.property.append([item[0]])
                name = '@property (nonatomic) NSArray *' + item[0] + ';'
            else:
                 names = item[0].split('_')
                n1 = names[0]
                for i in range(1, names.count()):
                    part = names[i]
                    n1 = n1+part[0].upper()+part[1:]
                name = '@property (nonatomic) NSString *'+n1+';'
                # self.property.append(n1 + n2)
            self.property.append(name)
            print name
        '''
        #Int类型

        pattern3 = re.compile(r"\"(.+?)\" *: *([0-9]+)")
        items = re.findall(pattern3, page)
        for item in items:

            if item[0].find('_') < 0:
                #self.property.append([item[0]])
                if item[0] == 'id':
                    name = 'identifier'
                else:
                    name = item[0]
            else:
                names = item[0].split('_')
                n1 = names[0]
                for i in range(1, len(names)):
                    part = names[i]
                    n1 = n1 + part[0].upper() + part[1:]
                name = n1
                #self.property.append(n1 + n2)
            pro = '@property (nonatomic, assign) NSInteger ' + name + ';'
            map = '@"' + item[0] + '" : @"' + name + '",'
            key = '@"'+item[0]+'",'
            self.property.append(pro)
            self.jsonMap.append(map)
            self.keys.append(key)

        #bool值

        pattern4 = re.compile(r"\"(.+?)\" *: *(true|false)")
        items = re.findall(pattern4, page)
        for item in items:

            if item[0].find('_') < 0:
                # self.property.append([item[0]])
                if item[0] == 'id':
                    name = 'identifier'
                else:
                    name = item[0]
            else:
                names = item[0].split('_')
                n1 = names[0]
                for i in range(1, len(names)):
                    part = names[i]
                    n1 = n1 + part[0].upper() + part[1:]
                name = n1
                # self.property.append(n1 + n2)
            pro = '@property (nonatomic, assign) BOOL ' + name + ';'
            map = '@"' + item[0] + '" : @"' + name + '",'
            key = '@"'+item[0]+'",'
            self.property.append(pro)
            self.jsonMap.append(map)
            self.keys.append(key)

        for item in self.property:
             self.result.insert(END, item + '\n')

    def clickBtn2(self):
        print 'click button2'
        self.result.delete('1.0',END)

        self.result.insert(END, 'static NSDictionary *config;\nif(!config){\n\tconfig=@{')
        for item in self.jsonMap:
            self.result.insert(END, item+'\n')
        self.result.insert(END, '};\n}\nreturn config;')

        self.result.insert(END, '\n\n')
        for key in self.keys:
            self.result.insert(END, key+'\n')

    def clickBtn3(self):
        self.text.delete('1.0', END)


top = Tkinter.Tk()
app = App(top)
top.mainloop()

