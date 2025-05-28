import SwiftUI

// 货运订单数据模型
struct PostLoad {
    let id = UUID()
    let title: String
    let carrier: String
    let origin: String
    let destination: String
    let weight: String
    let price: String
    let deadline: String
    let description: String
    let postedDate: String
    let contactName: String
}

struct TransportServiceView: View {
    @State private var searchText = ""
    @State private var selectedCarrier = "全部"
    @State private var isAnimated = false
    @State private var showPostForm = false
    
    // 运输商筛选选项
    let carriers = ["全部", "AMAZON", "WALMART", "FEDEX", "UPS", "USPS", "4PX", "USKY", "WAYFAIR", "NEWEGG", "SHEIN", "TIKTOK", "TEMU"]
    
    // 模拟货运订单数据
    let postLoads: [PostLoad] = [
        PostLoad(
            title: "洛杉矶到纽约整车运输",
            carrier: "AMAZON",
            origin: "洛杉矶, CA",
            destination: "纽约, NY",
            weight: "20,000 lbs",
            price: "$3,500",
            deadline: "2024-01-15",
            description: "需要运输电子产品，要求温控车厢",
            postedDate: "2024-01-05",
            contactName: "张先生"
        ),
        PostLoad(
            title: "芝加哥到迈阿密零担运输",
            carrier: "WALMART",
            origin: "芝加哥, IL",
            destination: "迈阿密, FL",
            weight: "5,000 lbs",
            price: "$1,200",
            deadline: "2024-01-18",
            description: "日用品运输，包装良好",
            postedDate: "2024-01-06",
            contactName: "李女士"
        ),
        PostLoad(
            title: "西雅图到丹佛快递运输",
            carrier: "FEDEX",
            origin: "西雅图, WA",
            destination: "丹佛, CO",
            weight: "500 lbs",
            price: "$800",
            deadline: "2024-01-12",
            description: "紧急医疗用品，优先配送",
            postedDate: "2024-01-07",
            contactName: "王医生"
        ),
        PostLoad(
            title: "达拉斯到休斯顿专线运输",
            carrier: "UPS",
            origin: "达拉斯, TX",
            destination: "休斯顿, TX",
            weight: "8,000 lbs",
            price: "$900",
            deadline: "2024-01-20",
            description: "工业设备运输，需要专业装卸",
            postedDate: "2024-01-08",
            contactName: "赵经理"
        ),
        PostLoad(
            title: "旧金山到拉斯维加斯小件运输",
            carrier: "USPS",
            origin: "旧金山, CA",
            destination: "拉斯维加斯, NV",
            weight: "200 lbs",
            price: "$350",
            deadline: "2024-01-16",
            description: "文件和小包裹运输",
            postedDate: "2024-01-09",
            contactName: "陈秘书"
        ),
        PostLoad(
            title: "波士顿到华盛顿跨境运输",
            carrier: "4PX",
            origin: "波士顿, MA",
            destination: "华盛顿, DC",
            weight: "3,000 lbs",
            price: "$750",
            deadline: "2024-01-22",
            description: "跨境电商货物，需要清关服务",
            postedDate: "2024-01-10",
            contactName: "刘总监"
        )
    ]
    
    // 筛选后的货运订单
    var filteredPostLoads: [PostLoad] {
        var filtered = postLoads
        
        // 按运输商筛选
        if selectedCarrier != "全部" {
            filtered = filtered.filter { $0.carrier == selectedCarrier }
        }
        
        // 按搜索文本筛选
        if !searchText.isEmpty {
            filtered = filtered.filter { 
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.origin.localizedCaseInsensitiveContains(searchText) ||
                $0.destination.localizedCaseInsensitiveContains(searchText) ||
                $0.carrier.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 搜索栏
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("搜索货运信息...", text: $searchText)
                        .font(.system(size: 17))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(red: 34/255, green: 139/255, blue: 34/255).opacity(0.1), Color(red: 34/255, green: 139/255, blue: 34/255).opacity(0.05)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .opacity(isAnimated ? 1 : 0)
                .offset(y: isAnimated ? 0 : -10)
                
                // 运输商筛选栏
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(carriers, id: \.self) { carrier in
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedCarrier = carrier
                                }
                            }) {
                                Text(carrier)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(selectedCarrier == carrier ? .white : Color(red: 34/255, green: 139/255, blue: 34/255))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(selectedCarrier == carrier ? 
                                                Color(red: 34/255, green: 139/255, blue: 34/255) : 
                                                Color(red: 34/255, green: 139/255, blue: 34/255).opacity(0.1)
                                            )
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.top, 12)
                .opacity(isAnimated ? 1 : 0)
                .offset(y: isAnimated ? 0 : -10)
                
                // 货运订单列表
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(Array(filteredPostLoads.enumerated()), id: \.element.id) { index, postLoad in
                            PostLoadCardView(postLoad: postLoad)
                                .opacity(isAnimated ? 1 : 0)
                                .offset(y: isAnimated ? 0 : 20)
                                .animation(DesignSystem.Animation.spring.delay(0.05 * Double(index)), value: isAnimated)
                        }
                        
                        if filteredPostLoads.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "truck.box")
                                    .font(.system(size: 48))
                                    .foregroundColor(.gray)
                                
                                Text("暂无匹配的货运信息")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                Text("试试调整筛选条件或搜索关键词")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray.opacity(0.8))
                            }
                            .padding(.top, 60)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
                .opacity(isAnimated ? 1 : 0)
                .offset(y: isAnimated ? 0 : 20)
            }
            .navigationTitle("陆运货源")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showPostForm = true
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .semibold))
                            Text("发布")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 34/255, green: 139/255, blue: 34/255), Color(red: 25/255, green: 100/255, blue: 25/255)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(20)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(DesignSystem.Animation.spring.delay(0.1)) {
                isAnimated = true
            }
        }
        .sheet(isPresented: $showPostForm) {
            PostLoadFormView()
        }
    }
}

// 货运订单卡片视图
struct PostLoadCardView: View {
    let postLoad: PostLoad
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // 处理点击事件，可以跳转到详情页
        }) {
            VStack(alignment: .leading, spacing: 12) {
                // 标题和运输商
                HStack {
                    Text(postLoad.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Text(postLoad.carrier)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(red: 34/255, green: 139/255, blue: 34/255))
                        .cornerRadius(8)
                }
                
                // 路线信息
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("起点")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(postLoad.origin)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black)
                    }
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 34/255, green: 139/255, blue: 34/255))
                        .padding(.horizontal, 8)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("终点")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(postLoad.destination)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                }
                
                // 重量、价格、截止日期
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "scalemass")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(postLoad.weight)
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "dollarsign.circle")
                            .font(.system(size: 12))
                            .foregroundColor(Color(red: 34/255, green: 139/255, blue: 34/255))
                        Text(postLoad.price)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(red: 34/255, green: 139/255, blue: 34/255))
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                            .foregroundColor(.orange)
                        Text(postLoad.deadline)
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                    }
                }
                
                // 描述
                Text(postLoad.description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                // 发布信息
                HStack {
                    Text("发布人: \(postLoad.contactName)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("发布于: \(postLoad.postedDate)")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.98 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// 发布货运信息表单视图
struct PostLoadFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title = ""
    @State private var selectedCarrier = "AMAZON"
    @State private var origin = ""
    @State private var destination = ""
    @State private var weight = ""
    @State private var price = ""
    @State private var deadline = Date()
    @State private var description = ""
    @State private var contactName = ""
    
    let carriers = ["AMAZON", "WALMART", "FEDEX", "UPS", "USPS", "4PX", "USKY", "WAYFAIR", "NEWEGG", "SHEIN", "TIKTOK", "TEMU"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 基本信息
                    VStack(alignment: .leading, spacing: 16) {
                        Text("基本信息")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("货运标题")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            TextField("例如：洛杉矶到纽约整车运输", text: $title)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("运输商")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            
                            Menu {
                                ForEach(carriers, id: \.self) { carrier in
                                    Button(carrier) {
                                        selectedCarrier = carrier
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedCarrier)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                    }
                    
                    // 路线信息
                    VStack(alignment: .leading, spacing: 16) {
                        Text("路线信息")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("起点")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            TextField("例如：洛杉矶, CA", text: $origin)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("终点")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            TextField("例如：纽约, NY", text: $destination)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                    }
                    
                    // 货物详情
                    VStack(alignment: .leading, spacing: 16) {
                        Text("货物详情")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("重量")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            TextField("例如：20,000 lbs", text: $weight)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("报价")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            TextField("例如：$3,500", text: $price)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("截止日期")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            DatePicker("", selection: $deadline, displayedComponents: .date)
                                .labelsHidden()
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("货物描述")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            TextField("例如：需要运输电子产品，要求温控车厢", text: $description, axis: .vertical)
                                .lineLimit(3...6)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("联系人")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)
                            TextField("例如：张先生", text: $contactName)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                    }
                    
                    // 发布按钮
                    Button(action: {
                        // 处理发布逻辑
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("发布货运信息")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(red: 34/255, green: 139/255, blue: 34/255), Color(red: 25/255, green: 100/255, blue: 25/255)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(12)
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
            .navigationTitle("发布货运信息")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

// 自定义文本框样式
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
    }
}

#Preview {
    TransportServiceView()
} 