
var sound:GameSound = new GameSound();
sound.playBGM("�T�E���h�̃����P�[�W��");

// �A�v���P�[�V��������A�N�e�B�u�ɂȂ�����
stage.addEventListener(Event.DEACTIVATE , OnDeactivateHandler); 
// �A�v���P�[�V�������A�N�e�B�u�ɂȂ�����
stage.addEventListener(Event.ACTIVATE, OnActivateHandler);
// ��A�N�e�B�u�ɂȂ�����
function OnDeactivateHandler(event:Event):void {
	sound.pauseAll();
	// ��A�N�e�B�u�ŏI������Ƃ���
	// NativeApplication.nativeApplication.exit();
}
// �A�N�e�B�u�ɂȂ�����
function OnActivateHandler(event:Event):void {
	sound.resumeAll();
}
