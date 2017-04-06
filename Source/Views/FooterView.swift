import UIKit

public protocol FooterViewDelegate: class {

  func footerView(_ footerView: FooterView, didExpand expanded: Bool)
}

open class FooterView: UIView {

  open fileprivate(set) lazy var infoLabel: InfoLabel = { [unowned self] in
    let label = InfoLabel(text: "")
    label.isHidden = !LightboxConfig.InfoLabel.enabled

    label.textColor = LightboxConfig.InfoLabel.textColor
    label.isUserInteractionEnabled = true
    label.delegate = self

    return label
  }()

  open fileprivate(set) lazy var pageLabel: UILabel = { [unowned self] in
    let label = UILabel(frame: CGRect.zero)
    label.isHidden = !LightboxConfig.PageIndicator.enabled
    label.numberOfLines = 1

    return label
  }()

  open weak var delegate: FooterViewDelegate?

  // MARK: - Initializers

  public init() {
    super.init(frame: CGRect.zero)

    backgroundColor = UIColor.clear

    [pageLabel, infoLabel].forEach { addSubview($0) }
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Helpers

  func expand(_ expand: Bool) {
    expand ? infoLabel.expand() : infoLabel.collapse()
  }

  func updatePage(_ page: Int, _ numberOfPages: Int) {
    let text = "\(page)/\(numberOfPages)"

    pageLabel.attributedText = NSAttributedString(string: text,
      attributes: LightboxConfig.PageIndicator.textAttributes)
    pageLabel.sizeToFit()
  }

  func updateText(_ text: String) {
    infoLabel.fullText = text
  }

  // MARK: - Layout

  fileprivate func resetFrames() {
    frame.size.height = infoLabel.frame.height + 40 + 0.5

    pageLabel.frame.origin = CGPoint(
      x: (frame.width - pageLabel.frame.width) / 2,
      y: frame.height - pageLabel.frame.height * 2)

    infoLabel.frame.origin.y = pageLabel.frame.minY - infoLabel.frame.height - 15

    resizeGradientLayer()
  }
}

// MARK: - LayoutConfigurable

extension FooterView: LayoutConfigurable {
  public func configureLayout() {
    infoLabel.frame = CGRect(x: 17, y: 0, width: frame.width - 17 * 2, height: 35)
    infoLabel.configureLayout()
  }
}

extension FooterView: InfoLabelDelegate {
  public func infoLabel(_ infoLabel: InfoLabel, didExpand expanded: Bool) {
    resetFrames()
    delegate?.footerView(self, didExpand: expanded)
  }
}
