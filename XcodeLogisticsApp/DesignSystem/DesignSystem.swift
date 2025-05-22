
import SwiftUI

// 观察对象，提供全局设计系统
class DesignSystem: ObservableObject {
    // MARK: - 颜色定义
    struct Colors {
        // 主色调
        static let blue = Color(UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1))
        static let blueDark = Color(UIColor(red: 10/255, green: 132/255, blue: 255/255, alpha: 1))
        
        // 辅助色调
        struct Gray {
            static let ultraLight = Color(UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1))
            static let light = Color(UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1))
            static let medium = Color(UIColor(red: 209/255, green: 209/255, blue: 214/255, alpha: 1))
            static let systemGray = Color(UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1))
            static let systemGray2 = Color(UIColor(red: 174/255, green: 174/255, blue: 178/255, alpha: 1))
            static let systemGray3 = Color(UIColor(red: 199/255, green: 199/255, blue: 204/255, alpha: 1))
            static let systemGray4 = Color(UIColor(red: 209/255, green: 209/255, blue: 214/255, alpha: 1))
            static let systemGray5 = Color(UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1))
            static let systemGray6 = Color(UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1))
        }
        
        // 语义色彩
        static let red = Color(UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1))
        static let orange = Color(UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1))
        static let yellow = Color(UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1))
        static let green = Color(UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1))
        static let teal = Color(UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1))
        static let indigo = Color(UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1))
        static let purple = Color(UIColor(red: 175/255, green: 82/255, blue: 222/255, alpha: 1))
        static let pink = Color(UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1))
        
        // 背景和前景
        static let background = Color.white
        static let foreground = Color.black
        
        // 标签颜色
        struct Label {
            static let primary = Color.black
            static let secondary = Color.black.opacity(0.75)
            static let tertiary = Color.black.opacity(0.60)
            static let quaternary = Color.black.opacity(0.40)
        }
        
        // 填充色
        struct Fill {
            static let primary = Color(UIColor(red: 120/255, green: 120/255, blue: 128/255, alpha: 0.2))
            static let secondary = Color(UIColor(red: 120/255, green: 120/255, blue: 128/255, alpha: 0.16))
            static let tertiary = Color(UIColor(red: 118/255, green: 118/255, blue: 128/255, alpha: 0.12))
            static let quaternary = Color(UIColor(red: 116/255, green: 116/255, blue: 128/255, alpha: 0.08))
        }
        
        // 分组背景
        struct GroupedBackground {
            static let primary = Color(UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1))
            static let secondary = Color.white
            static let tertiary = Color(UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1))
        }
        
        // 分隔线
        static let separator = Color.black.opacity(0.29)
        static let opaqueSeparator = Color(UIColor(red: 198/255, green: 198/255, blue: 200/255, alpha: 1))
    }
    
    // MARK: - 动画定义
    struct Animation {
        // 标准过渡效果
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        
        // 弹簧效果
        static let spring = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.1)
        static let bouncy = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.1)
        
        // 进入和退出效果
        struct Transition {
            static let slide = AnyTransition.move(edge: .bottom).combined(with: .opacity)
            static let scale = AnyTransition.scale.combined(with: .opacity)
            static let fade = AnyTransition.opacity
        }
    }
    
    // MARK: - 尺寸和间距
    struct Layout {
        struct CornerRadius {
            static let small: CGFloat = 6
            static let medium: CGFloat = 8
            static let large: CGFloat = 12
            static let extraLarge: CGFloat = 16
            static let xxLarge: CGFloat = 22
            static let button: CGFloat = 10
        }
        
        struct Shadow {
            let color: Color
            let radius: CGFloat
            let x: CGFloat
            let y: CGFloat

            static let small = Shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 2)
            static let medium = Shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)
            static let large = Shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 10)
            static let elevatedButton = Shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
            static let floatingButton = Shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
        }
        
        struct Padding {
            static let small: CGFloat = 8
            static let medium: CGFloat = 16
            static let large: CGFloat = 24
        }
        
        struct Spacing {
            static let small: CGFloat = 8
            static let medium: CGFloat = 16
            static let large: CGFloat = 24
        }
    }
}

// MARK: - 扩展实用工具
extension View {
    // 苹果卡片样式
    func appleCard() -> some View {
        self
            .background(Color.white)
            .cornerRadius(DesignSystem.Layout.CornerRadius.large)
            .shadow(color: Color.black.opacity(0.06), radius: 7, x: 0, y: 2)
    }
    
    // 苹果按钮样式
    func appleButton() -> some View {
        self
            .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
    
    // 苹果浮动按钮样式
    func appleFloatingButton() -> some View {
        self
            .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
    }
    
    // 模糊背景
    func appleBlurBackground(opacity: Double = 0.6) -> some View {
        self
            .background(
                BlurView(style: .systemThinMaterial)
                    .opacity(opacity)
            )
    }
}

// MARK: - UIKit模糊视图封装
struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
