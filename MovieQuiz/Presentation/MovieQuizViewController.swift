import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    
//    Mark -- Аутлеты --

    @IBOutlet private var noButtonOutlet: UIButton!
    @IBOutlet private var yesButtonOutlet: UIButton!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var questionLabel: UILabel!
    
    
//    Mark -- пока хз что это --
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 9
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
   
    // Функция, которая отключает кнопки
    private func enabledButton(switchButton: Bool){
        if switchButton{
            noButtonOutlet.isEnabled = true
            yesButtonOutlet.isEnabled = true
        }else{
            noButtonOutlet.isEnabled = false
            yesButtonOutlet.isEnabled = false
        }

    }
    
    //    ------ кнопка нет ------
    @IBAction private func noButtonClicked(_ sender: Any) {
        enabledButton(switchButton: false)
        let answer = false
        guard let check = currentQuestion else { return }
    
        showAnswerResult(isCorrect: answer == check.correctAnswer)
    }
    
    //   ------ кнопка да ------
    @IBAction private func yesButtonClicked(_ sender: Any) {
        enabledButton(switchButton: false)
        let answer = true
        guard let check = currentQuestion else { return }
        
        showAnswerResult(isCorrect: answer == check.correctAnswer)
    }
    
    //   ------ функция считает правильные ответы и запускает новый вопрос ------
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect{
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
    }
    
    //   ------ функция проверяет, показывать ли следующий вопрос или выдать алерт с результатами ------
    private func showNextQuestionOrResults() {
        enabledButton(switchButton: true)
        if currentQuestionIndex == questionsAmount - 1 {
            let text = correctAnswers == questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз")
            {[weak self] in self?.restartQuiz()}

            alertPresenter?.showAlert(with: alertModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    //   ------ функция дидресивнекстквещен ------
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    //   ------ функция конвертация из моковых данных в нужный формат для показа данных на экране ------
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    //   ------ функция которая показывает вопрос на экран ------
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    //   ------ рестарт квиза ------
    private func restartQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    //   ------ Тут мы устанавливаем стили шрифтов ------
    private func setupViews(){
        questionLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        noButtonOutlet.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButtonOutlet.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
    }
    
    //   ------ функция делает статус бар (где время, WIFI и батарея) белым цветом ------
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        let questionFactory = QuestionFactory() // 2
        questionFactory.delegate = self         // 3
        self.questionFactory = questionFactory  // 4
        
        questionFactory.requestNextQuestion()
        
        alertPresenter = AlertPresenter(viewController: self)
    }
}











