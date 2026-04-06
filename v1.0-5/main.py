# vcd-man: a video-to-VCD converter in 200 lines
# built on the 6th April 2026 by lostsss, released under GPLv3
import PyQt5
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *
from PyQt5.QtGui import *
import sys
from subprocess import Popen
import threading
import os
import shutil
from pathlib import Path
import datetime
from time import sleep as sleepTime

# --- SETUP ---
windowFlags = (
    Qt.WindowType.Window
    | Qt.WindowType.WindowMinimizeButtonHint
    | Qt.WindowType.WindowCloseButtonHint
)

app = QApplication(sys.argv) # Application object
app.setQuitOnLastWindowClosed(True)
window = QMainWindow() # Create a window
window.setWindowTitle("vcd-man") # Set title
window.setGeometry(100, 100, 400, 145) # Set size (x, y, width, height)
window.setWindowFlags(windowFlags)
window.setFixedSize(window.size())
window.show()

centralWidget = QWidget()
mainLayout = QHBoxLayout(centralWidget)

inputFile = ""
status = "Load a file to begin!"
isSavingTempFiles = False
isTextRefreshThreadUp = True

def textRefresh():
    global inputFile, status, isTextRefreshThreadUp
    while True:
        objects['ChosenFileText'].setText(inputFile)
        objects['ProgressText'].setText(status)
        ToggleSavingTempFilesMenu.setTitle(f"Save Temp Files? (Currently {isSavingTempFiles})")

def closeEvent(self, event):
    global isTextRefreshThreadUp
    isTextRefreshThreadUp = False
    QApplication.quit()

def saveInputFile(file):
    global inputFile
    inputFile = file

try:
    shutil.rmtree("temp/")
except:
    pass
os.mkdir("temp/")

def videoToVCD(source):
        global status
        status = "Converting video..."
        p = Popen(f'ffmpeg -i "{source}" \
-target pal-vcd \
-vf "scale=352:288:force_original_aspect_ratio=decrease,pad=352:288:(ow-iw)/2:(oh-ih)/2" \
temp/temp.mpg\necho Finished converting video', shell=True)
        p.communicate()
        status = "Finished converting video."
        sleepTime(1)
        status = "Making CD data files..."
        p = Popen('vcdimager -t vcd2 -c temp/temp.cue -b temp/temp.bin temp/temp.mpg', shell=True)
        p.communicate()
        status = "Finished making CD data files."
        sleepTime(1)
        status = "Moving files..."
        sourceName = Path(f"{source}").stem.replace("/", "_").replace("\\", "_").replace(":", "_").replace(".", "_").replace("<", "_").replace(">", "_").replace('"', "_").replace("|", "_").replace("?", "_").replace("*", "_")
        currentDatetime = datetime.datetime.now()
        currentDatetime = currentDatetime.strftime("%y%m%d-%H%M%S")
        os.mkdir(currentDatetime)
        p = Popen(f'cp temp/temp.bin "{currentDatetime}/saved_temp/{sourceName}.bin"', shell=True)
        p.communicate()
        p = Popen(f'cp temp/temp.cue "{currentDatetime}/saved_temp/{sourceName}.cue"', shell=True)
        p.communicate()
        if isSavingTempFiles:
            status = "Finished moving files."
            sleepTime(1)
            status = "Saving temp files as defined in Settings..."
            os.mkdir(f"{currentDatetime}/saved_temp/")
            p = Popen(f'cp temp/temp.mpg "{currentDatetime}/saved_temp/{sourceName}.mpg"', shell=True)
            p.communicate()
            status = "Finished saving temp files as defined in Settings..."
            sleepTime(1)
        status = "Finished moving files."
        sleepTime(1)
        
        try:
            shutil.rmtree("temp/")
        except:
            pass

        status = "Finished job."
        sys.exit()

def launchVideoToVCD(source):
    videoToVCDThread = threading.Thread(target=videoToVCD, kwargs={'source': source})
    videoToVCDThread.start()

# --- FILE DRAG+DROP ---
class DropButton(QPushButton): # https://github.com/akkana/scripts/blob/master/qdroptarget.py
    def __init__(self, parent, command=None, label="Drop here"):
        self.title = label
        self.command = command

        super().__init__(self.title, parent)

        self.setAcceptDrops(True)

        self.timer = QTimer()
        self.timer.setSingleShot(True)
        self.timer.setInterval(1000)

        self.inverted = False

    def dragEnterEvent(self, e):
        e.accept()
    
    def dropEvent(self, e):
        text = e.mimeData().text()
        text = text.replace("file://", "")
        self.timer.start()
        self.command(text)
        print("Dropped:", text)

# --- MENU BAR ---
class MenuBar:
    def toggleSavingTempFiles(val):
        global isSavingTempFiles
        isSavingTempFiles = val

    def start():
        global status, ToggleSavingTempFilesMenu
        menuBar = window.menuBar()
        menuBar.setNativeMenuBar(True)

        SettingsMenu = menuBar.addMenu("Settings")
        ToggleSavingTempFilesMenu = SettingsMenu.addMenu("Save Temp Files?")

        YESSavingTempFilesAction = QAction('True', window)
        YESSavingTempFilesAction.triggered.connect(lambda: MenuBar.toggleSavingTempFiles(True))
        YESSavingTempFilesButton = ToggleSavingTempFilesMenu.addAction(YESSavingTempFilesAction)

        NOSavingTempFilesAction = QAction('False', window)
        NOSavingTempFilesAction.triggered.connect(lambda: MenuBar.toggleSavingTempFiles(False))
        NOSavingTempFilesButton = ToggleSavingTempFilesMenu.addAction(NOSavingTempFilesAction)

# --- PAGES ---
class HomePage:
    global objects
    objects = {}
    def start():
        verticalLayout = QVBoxLayout()
        mainLayout.addLayout(verticalLayout)

        objects['FileInputBaseButton'] = QPushButton() # Creates a base
        verticalLayout.addWidget(objects['FileInputBaseButton']) # Adds base to parent
        objects['FileInputBaseButton'].setVisible(False) # Hides base
        objects['FileInputDropPoint'] = DropButton(objects['FileInputBaseButton'], command=saveInputFile, label="Drag Input File Here") # Creates the Drag 'n' Drop object
        verticalLayout.addWidget(objects['FileInputDropPoint']) # Adds the Drag 'n' Drop object to parent

        objects['ChosenFileText'] = QLabel()
        verticalLayout.addWidget(objects['ChosenFileText'])
        objects['ChosenFileText'].setText(inputFile)

        objects['GoButton'] = QPushButton()
        verticalLayout.addWidget(objects['GoButton'])
        objects['GoButton'].setText("Create VideoCD of File")
        objects['GoButton'].clicked.connect(lambda:launchVideoToVCD(inputFile))
        
        objects['GoButton'].setEnabled(True)
        objects['GoButton'].setCheckable(True)
        objects['GoButton'].setDefault(True)

        objects['ProgressText'] = QLabel()
        verticalLayout.addWidget(objects['ProgressText'])
        objects['ProgressText'].setText("Upload a file to begin!")

HomePage.start()
MenuBar.start()

textRefreshThread = threading.Thread(target=textRefresh, daemon=True)
textRefreshThread.start()

mainLayout.update()
mainLayout.activate()

window.setCentralWidget(centralWidget)
window.show() # Show the window
sys.exit(app.exec()) # Run the application loop