import UIKit


final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var noButtonOutlet: UIButton!
    @IBOutlet private var yesButtonOutlet: UIButton!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var questionLabel: UILabel!
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
    ]
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    private struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    // вью модель для состояния "Вопрос показан"
    private struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    // отключаем кнопки
    private func enabledButton(switchButton: Bool){
        if switchButton{
            noButtonOutlet.isEnabled = true
            yesButtonOutlet.isEnabled = true
        }else{
            noButtonOutlet.isEnabled = false
            yesButtonOutlet.isEnabled = false
        }

    }
    
    //    кнопка нет
    @IBAction private func noButtonClicked(_ sender: Any) {
        enabledButton(switchButton: false)
        let answer = false
        let check = questions[currentQuestionIndex]
        
        showAnswerResult(isCorrect: answer == check.correctAnswer)
    }
    //    кнопка да
    @IBAction private func yesButtonClicked(_ sender: Any) {
        enabledButton(switchButton: false)
        let answer = true
        let check = questions[currentQuestionIndex]
        
        showAnswerResult(isCorrect: answer == check.correctAnswer)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect{
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
            
        }
    }
    
    private func showNextQuestionOrResults() {
        enabledButton(switchButton: true)
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers)/10" // 1
            let viewModel = QuizResultsViewModel( // 2
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel) // 3
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupViews(){
        questionLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        noButtonOutlet.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButtonOutlet.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //      настройки шрифта
        setupViews()
        let currentQuestion = questions[currentQuestionIndex]
        let viewModel = convert(model: currentQuestion)
        show(quiz: viewModel)
    }
    
}











