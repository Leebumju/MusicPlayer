//
//  ViewController.swift
//  MusicPlayer
//
//  Created by 이범준 on 2021/10/22.
//

import UIKit
import AVFoundation
    
    class ViewController: UIViewController, AVAudioPlayerDelegate { //AVAudioPlayerDelegate - 오디오 재생 이벤트 및 디코딩 오류에 응답하는 메서드를 정의하는 프로토콜입니다.
        
    // MARK:- Properties
    var player: AVAudioPlayer! //AVAudioPlayer - 파일 또는 버퍼에서 오디오 데이터를 재생하는 개체입니다.
    var timer: Timer! // Timer - 특정 시간 간격 이후에 발사되는 타이머가 경과하여 지정된 메시지를 대상 개체로 전송합니다.
        
    // MARK: IBOutlets
    @IBOutlet var playPauseButton: UIButton! //UI버튼 - 사용자 상호 작용에 대한 응답으로 사용자 지정 코드를 실행하는 컨트롤입니다.
    @IBOutlet var timeLabel: UILabel! // UILabel - 하나 이상의 정보 텍스트 줄이 표시되는 뷰입니다.
    @IBOutlet var progressSlider: UISlider! // UISlider - 연속 값 범위에서 단일 값을 선택하는 컨트롤입니다.
        
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.addViewsWithCode()
        self.initializePlayer() // 플레이어 초기화 메서드 실행
    }

    // MARK: - Methods
    // MARK: Custom Method
    // 플레이어를 초기화하는 메서드
    func initializePlayer() {
        
        guard let soundAsset: NSDataAsset = NSDataAsset(name: "sound") else { //guard문의 조건이 참일 경우 pass , NSDataAsset - An object from a data set type stored in an asset catalog.
            print("음원 파일 에셋을 가져올 수 없습니다") //예외처리같은 느낌인데? 사운드파일 있으면 가져오고 아니면 밑에 문장 출력하고.
            return
        }
        
        do { //예외사항 처리를 위해 do~catch &try 문 사용
            try self.player = AVAudioPlayer(data: soundAsset.data) //AVAudioPlayer 인스턴스 생성
            self.player.delegate = self //AVaudioPlayer의 델리게이트는 ViewController
        } catch let error as NSError {// NSError - 도메인, 도메인 별 오류 코드 및 응용 프로그램 별 정보를 포함한 오류 조건에 대한 정보입니다.
            //as , is - 형변환은 Instance의 타입을 확인하거나, Instance를 superclass 혹은 subclass로 취급하여 처리하기 위해 필요한 작업. is와 as로 구별되며, is는 Instance의 타입을 확인하는데 사용되며, as는 Instance의 형변환 작업에 이용되는 명령어이다.
            print("플레이어 초기화 실패")
            print("코드 : \(error.code), 메세지 : \(error.localizedDescription)")
        }
        
        self.progressSlider.maximumValue = Float(self.player.duration) //UIslider 최대값을 player의 프로퍼티 duration으로 초기화
        self.progressSlider.minimumValue = 0 //UISlider의 최소값 초기화
        self.progressSlider.value = Float(self.player.currentTime) //UISlider의 값을 player의 프로퍼티 currentTime으로 초기화
    }

        
    func updateTimeLabelText(time: TimeInterval) { //매 초마다 레이블을 업데이트해주는 메서드
        let minute: Int = Int(time / 60) //
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        let milisecond: Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)
        
        let timeText: String = String(format: "%02ld:%02ld:%02ld", minute, second, milisecond) //지정 포맷에 따라 시간 출력
        
        self.timeLabel.text = timeText
    }
        
        
    
    func makeAndFireTimer() { //타이머를 만들고 수행할 메서드
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] (timer: Timer) in
          
            if self.progressSlider.isTracking { return }
            
            self.updateTimeLabelText(time: self.player.currentTime)
            self.progressSlider.value = Float(self.player.currentTime)
        })
        self.timer.fire()
    }
    
        
    func invalidateTimer() { //타이머를 해제해 줄 메서드
        self.timer.invalidate() //타이머 기능 정지
        self.timer = nil
    }
    
    func addViewsWithCode() {
        self.addPlayPauseButton()
        self.addTimeLabel()
        self.addProgressSlider()
    }
    
    func addPlayPauseButton() {
        
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(button)
        
        button.setImage(UIImage(named: "button_play"), for: UIControl.State.normal)
        button.setImage(UIImage(named: "button_pause"), for: UIControl.State.selected)
        
        button.addTarget(self, action: #selector(self.touchUpPlayPauseButton(_:)), for: UIControl.Event.touchUpInside)
        
        let centerX: NSLayoutConstraint
        centerX = button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        
        let centerY: NSLayoutConstraint
        centerY = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 0.8, constant: 0)
        
        let width: NSLayoutConstraint
        width = button.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3)
        
        let ratio: NSLayoutConstraint
        ratio = button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1)
        
        centerX.isActive = true
        centerY.isActive = true
        width.isActive = true
        ratio.isActive = true
        
        self.playPauseButton = button
    }
    
    func addTimeLabel() {
        let timeLabel: UILabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(timeLabel)
        
        timeLabel.textColor = UIColor.black
        timeLabel.textAlignment = NSTextAlignment.center
        timeLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        
        let centerX: NSLayoutConstraint
        centerX = timeLabel.centerXAnchor.constraint(equalTo: self.playPauseButton.centerXAnchor)
        
        let top: NSLayoutConstraint
        top = timeLabel.topAnchor.constraint(equalTo: self.playPauseButton.bottomAnchor, constant: 8)
        
        centerX.isActive = true
        top.isActive = true
        
        self.timeLabel = timeLabel
        self.updateTimeLabelText(time: 0)
    }
    
    func addProgressSlider() {
        let slider: UISlider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(slider)
        
        slider.minimumTrackTintColor = UIColor.red
        
        slider.addTarget(self, action: #selector(self.sliderValueChanged(_:)), for: UIControl.Event.valueChanged)
        
        let safeAreaGuide: UILayoutGuide = self.view.safeAreaLayoutGuide
        
        let centerX: NSLayoutConstraint
        centerX = slider.centerXAnchor.constraint(equalTo: self.timeLabel.centerXAnchor)
        
        let top: NSLayoutConstraint
        top = slider.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: 8)
        
        let leading: NSLayoutConstraint
        leading = slider.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16)
        
        let trailing: NSLayoutConstraint
        trailing = slider.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16)
        
        centerX.isActive = true
        top.isActive = true
        leading.isActive = true
        trailing.isActive = true
        
        self.progressSlider = slider
    }
    
    // MARK: IBActions
    @IBAction func touchUpPlayPauseButton(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            self.player?.play()
        } else {
            self.player?.pause()
        }
        
        if sender.isSelected {
            self.makeAndFireTimer()
        } else {
            self.invalidateTimer()
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        self.updateTimeLabelText(time: TimeInterval(sender.value))
        if sender.isTracking { return }
        self.player.currentTime = TimeInterval(sender.value)
    }
    
    
    // MARK: AVAudioPlayerDelegate
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
        guard let error: Error = error else { //guard조건이 참이면 그냥 지나가고, 틀리면 else문 진행
            print("오디오 플레이어 디코드 오류발생")
            return
        }
        
        // let error: Error = error 일 경우 진행
        let message: String
        message = "오디오 플레이어 오류 발생 \(error.localizedDescription)"
        
        //creating an Alert Controller
        //alert를 발생시키기 위해 UIAlertController클래스의 인스턴스를 alert라는 이름으로 생성한다.
        let alert: UIAlertController = UIAlertController(title: "알림", message: message, preferredStyle: UIAlertController.Style.alert)
        
        //An Action that can ve taken when user taps a button in an alert
        //유저가 띄워진 경고창에서 버튼을 클릭했을때의 액션을 취함
        //Creation an Alert Action
        let okAction: UIAlertAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (action: UIAlertAction) -> Void in //closure 사용
            
            self.dismiss(animated: true, completion: nil) //ok 버튼 클릭시 경고창 내리기
        }
        
        alert.addAction(okAction) //Action 더하기
        self.present(alert, animated: true, completion: nil)
    }
    
        //Responding to Sound Playback Completion
        //func audioPlayDidFinishPlaying(AVAudioPlayer, scuccessfully: Bool)
        //Called when a sound has finished playing -> 노래가 끝나면 호출되는 함수.
        
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playPauseButton.isSelected = false
        self.progressSlider.value = 0
        self.updateTimeLabelText(time: 0)
        self.invalidateTimer()
    }
    
}


