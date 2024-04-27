import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    
//    Mark -- Outlets --

    @IBOutlet private var noButtonOutlet: UIButton!
    @IBOutlet private var yesButtonOutlet: UIButton!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var questionLabel: UILabel!
    
    
//    Mark -- Нужные значения --
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    
//    Mark -- Делегаты и взаимодействия между классами --
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    
    
//   Mark -- LifeCycle --
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        questionFactory = QuestionFactory(delegate: self)
        statisticService = StatisticServiceImplementation()
        alertPresenter = AlertPresenter(viewController: self)
        setupBorder(isHidden: true)
        questionFactory?.requestNextQuestion()
    }
    
//   Mark -- Actions --
   
    //   метод который отключает кнопки
    private func enabledButton(switchButton: Bool){
        if switchButton{
            noButtonOutlet.isEnabled = true
            yesButtonOutlet.isEnabled = true
        }else{
            noButtonOutlet.isEnabled = false
            yesButtonOutlet.isEnabled = false
        }
    }
    
    //   кнопка нет
    @IBAction private func noButtonClicked(_ sender: Any) {
        enabledButton(switchButton: false)
        let answer = false
        guard let check = currentQuestion else { return }
    
        showAnswerResult(isCorrect: answer == check.correctAnswer)
    }
    
    //   кнопка да
    @IBAction private func yesButtonClicked(_ sender: Any) {
        enabledButton(switchButton: false)
        let answer = true
        guard let check = currentQuestion else { return }
        
        showAnswerResult(isCorrect: answer == check.correctAnswer)
    }
    
//   Mark -- не знаю как назвать --
    
    //   ------ метод настройки показа вопроса. Вынесли отдельно сюда, чтобы не плодить лишний код ------
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.show(quiz: viewModel)
        }
    }
    
//   Mark -- Приватные методы --
    
    //   ------ метод считает правильные ответы и запускает новый вопрос ------
    private func showAnswerResult(isCorrect: Bool) {
        setupBorder(isHidden: false)
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        if isCorrect { correctAnswers += 1 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    //   ------ метод проверяет, показывать ли следующий вопрос или выдать алерт с результатами ------
    private func showNextQuestionOrResults() {
        enabledButton(switchButton: true)
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            let quizResultsViewModel = QuizResultsViewModel(title: "Этот раунд окончен!",
                                                            text: createMessage(),
                                                            buttonText: "Сыграть еще раз")
            show(quiz: quizResultsViewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }

    //   ------ метод конвертации из моковых данных в нужный формат для показа данных на экране ------
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    //   ------ метод который показывает вопрос на экран ------
    private func show(quiz step: QuizStepViewModel) {
        setupBorder(isHidden: true)
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
    
    private func setupBorder(isHidden: Bool){
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = isHidden ? 0 : 8
        imageView.layer.cornerRadius = 20
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        alertPresenter?.showResult(with: AlertModel(title: result.title, message: result.text, buttonText: result.buttonText, completion: { [weak self] _ in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }))
    }
    
    private func createMessage() -> String {
        guard let statisticService = statisticService else { return "" }
        let bestGame = statisticService.bestGame
        let result: String = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        let count: String = "Количество сыгранных игр: \(statisticService.gamesCount)"
        let record: String = "Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))"
        let totalAccuracy: String = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        return [result, count, record, totalAccuracy].joined(separator: "\n")
    }

//   Mark -- Сетап внешнего вида по ТЗ --
    
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
}











