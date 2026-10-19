# Kịch bản thuyết trình SRS BrewBoss — 4 sơ đồ

Thứ tự trình bày: **Organization structure → Context diagram → Use case diagram → Main workflow.**
Bám theo `SRS_PRM393_G2_Cafe_Shop_Management.docx` bản 19/10/2026 (đã sửa sau review của giảng viên).

| Phần | Hình trong SRS | Thời lượng | Bản rút gọn 8 phút |
|---|---|---|---|
| 1. Organization structure | Figure 1-2 (Starbucks), Figure 1-3 (BrewBoss), bảng ánh xạ, bảng bằng chứng | 3–4 phút | 2 phút: bỏ đoạn đọc từng tầng Starbucks, chỉ nói ý "suy ra từ mô tả vị trí" |
| 2. Context diagram | Figure 1-1 | 3 phút | 1,5 phút: chỉ nói Cashier, Customer, VietQR |
| 3. Use case diagram | Figure 2-3 → 2-7 (D1–D5), 2-8 → 2-13 (A1–A6) | 5–6 phút | 3 phút: chỉ D1, D3, D4 |
| 4. Main workflow | Figure 2-1 (một ngày vận hành), Figure 2-2 (state machine) | 3–4 phút | 1,5 phút: chỉ giai đoạn Serve customers |

Quy ước: chữ trong `[ngoặc vuông]` là chỉ dẫn (chỉ hình, chuyển slide), không đọc. Chữ trong ngoặc kép là lời nói. Mỗi phần có Q&A dự phòng; không đọc Q&A khi trình bày.

Chuẩn bị trước buổi: mở file SRS bằng Word, chọn **Yes** khi được hỏi cập nhật field để mục lục có 5.5 và 5.6; đánh dấu sẵn các trang Figure 1-1, 1-2, 1-3, 2-1, 2-3, 2-5, 2-13 và trang bảng bằng chứng dưới Figure 1-2.

---

## 0. Mở đầu (20 giây)

[Chiếu trang bìa SRS]

“Thưa thầy và các bạn, nhóm em trình bày phần yêu cầu của BrewBoss, ứng dụng quản lý quán cà phê trên Flutter và Firebase. Em đi theo bốn sơ đồ: cơ cấu tổ chức của quán, sơ đồ ngữ cảnh, use case theo từng vai trò, và quy trình vận hành chính trong một ngày. Sau review lần trước, cơ cấu tổ chức đã được làm lại theo mô hình cửa hàng của Starbucks và có ghi nguồn, nên em bắt đầu từ đó.”

---

## 1. Organization structure (3–4 phút)

### 1.1 Figure 1-2 — mô hình tham chiếu Starbucks

[Chiếu Figure 1-2]

“Đây là cơ cấu tổ chức cấp cửa hàng của Starbucks, nhóm dùng làm mô hình tham chiếu. Em nói rõ trước một điểm: Starbucks không công bố sơ đồ tổ chức. Sơ đồ này được nhóm suy ra từ mô tả vị trí trên bốn trang chính thức của Starbucks: trang tuyển dụng Mỹ, trang Úc, trang Indonesia và trang Đức, tương ứng nguồn [1] đến [4] trong mục 5.5. Mỗi ô trên hình ghi số nguồn của câu dùng để suy ra.

[Chỉ ô District Manager ở trên cùng]

Trên cùng là District Manager, quản lý một cụm cửa hàng. Trang Indonesia ghi vị trí này ‘manage the overall operations of eight to ten stores’ và ‘manage district-wide store management team’. Cấp này nằm ngoài khung nét đứt, nghĩa là ngoài một cửa hàng.

[Chỉ khung nét đứt ‘One Starbucks coffeehouse’]

Trong một cửa hàng có bốn tầng. Store Manager: trang Úc ghi ‘managing the overall operation of the store including supervising and directing the workforce’. Assistant Store Manager: ‘assisting the store manager in executing store operations’ và ‘supervising a team of store partners’. Shift Supervisor: ‘assisting the store manager in executing store operations during shifts’ và ‘directing partners to various workstations’; chương trình đào tạo của vị trí này có ‘cash controller responsibilities’. Dưới cùng là Barista, được trưởng ca phân vào các vị trí làm việc.

[Chỉ ô Customer nét đứt]

Khách hàng là bên ngoài tổ chức: thành viên Starbucks Rewards, đặt và trả tiền trước trên app, tích sao theo chi tiêu.

[Chỉ bảng bằng chứng ngay dưới hình]

Ngay dưới hình là bảng bằng chứng: mỗi đường báo cáo trên sơ đồ đi kèm câu trích nguyên văn và số nguồn. Ảnh chụp màn hình từng trang, có bấm đúng tab, nằm ở phụ lục 5.6.”

### 1.2 Figure 1-3 — cơ cấu BrewBoss áp dụng

[Chiếu Figure 1-3]

“BrewBoss nhắm tới một quán đơn lẻ, tương đương một cửa hàng trong khung nét đứt vừa rồi. Vì vậy District Manager và trụ sở nằm ngoài phạm vi; phần quản lý nhiều chi nhánh đã ghi trong mục ngoài phạm vi của SRS.

[Chỉ ô Owner / Manager]

Owner / Manager tương ứng Store Manager cộng Assistant Store Manager, vì quán một chi nhánh chỉ có một người quản lý. Vai trò này thiết lập menu, công thức, nhân viên, nguyên liệu, bàn, voucher; xem báo cáo và bàn giao tiền. Manager có toàn bộ quyền của các vai trò bên dưới.

[Chỉ ô Shift Supervisor]

Shift Supervisor, tiếng Việt là trưởng ca, là vai trò mới thêm sau review, lấy từ Shift Supervisor của Starbucks. Mỗi ca có một trưởng ca, dùng tablet quầy hoặc điện thoại. Trưởng ca điều phối thu ngân và pha chế, là cấp thấp nhất được huỷ đơn khi pha chế đã bắt đầu, thực hiện kiểm kho và xem báo cáo tiền của từng ca. Trưởng ca kế thừa toàn bộ quyền của thu ngân và pha chế.

[Chỉ hai ô Cashier và Barista]

Ở Starbucks, Barista được trưởng ca phân vào vị trí quầy hoặc vị trí bar trong ca. BrewBoss tách hai vị trí đó thành hai vai trò Cashier và Barista, vì tablet quầy và tablet bar là hai thiết bị riêng với màn hình khác nhau. Thu ngân mở ca với tiền đầu ca, tạo và xác nhận đơn, phục vụ, thu tiền, bàn giao tiền cuối ca. Pha chế làm việc trên hàng đợi đơn và bấm xong theo từng lượt; ca của pha chế không có phần tiền.

[Chỉ các đường nối]

Đường liền là quan hệ quản lý trực thuộc: Manager quản lý trưởng ca; trưởng ca quản lý thu ngân và pha chế. Đường nét đứt hai chiều giữa thu ngân và pha chế là phối hợp trong ca: gửi đơn sang bar, bar báo món sẵn sàng; việc này đi qua BrewBoss. Mũi tên ‘serves’ xuống khách hàng là quan hệ phục vụ, không phải quan hệ quản lý.

[Chỉ bảng ánh xạ]

Bảng ánh xạ ngay sau hình tóm tắt: mỗi vai trò Starbucks ứng với vai trò nào trong app, app role lưu trong Firestore là gì, và lý do gộp hoặc tách. Từ bốn vai trò nhân viên này, nhóm xây dựng bảng phân quyền màn hình ở mục 3.1.3.”

### Q&A phần 1

**1. Vì sao chọn Starbucks mà không chọn chuỗi Việt Nam như Highlands?**
“Dạ, Starbucks là chuỗi lớn nhất và công bố mô tả vị trí đầy đủ cho cả năm cấp, từ Barista đến District Manager, trên trang chính thức. Highlands chỉ đăng tin tuyển quản lý cửa hàng và store manager trainee; nhóm vẫn dùng hai tin đó, nguồn [5] và [6], để đối chiếu nhiệm vụ quản lý cửa hàng và việc đào tạo xử lý tiền mặt, kiểm kê.”

**2. Trang nào của Starbucks nói cấu trúc như vậy?**
“Dạ, không trang nào vẽ sơ đồ. Nhóm suy ra từ các câu mô tả vị trí: trưởng ca ‘assisting the store manager’, District Manager ‘manage district-wide store management team’. Bảng bằng chứng dưới Figure 1-2 liệt kê đủ câu và số nguồn, ảnh chụp ở mục 5.6.”

**3. Vì sao không có Assistant Store Manager trong BrewBoss?**
“Dạ, quán một chi nhánh chỉ cần một người quản lý; nhiệm vụ của Assistant Store Manager được gộp vào Owner / Manager. Bảng ánh xạ ghi rõ việc gộp này.”

**4. Trưởng ca khác quản lý ở điểm nào trong app?**
“Dạ, trưởng ca không có quyền thiết lập: không sửa menu, công thức, nhân viên, voucher, không xem dashboard doanh thu và báo cáo bán hàng. Trưởng ca có thêm ba việc so với thu ngân: huỷ đơn đã bắt đầu pha, kiểm kho, xem báo cáo tiền ca. Chi tiết ở cột Supervisor trong bảng 3.1.3.”

**5. Một người vừa là quản lý vừa đứng quầy thì sao?**
“Dạ, mỗi tài khoản chỉ có một role, nhưng role cao hơn có mọi quyền của role thấp hơn. Quản lý đứng quầy vẫn dùng tài khoản manager, chỉ cần mở ca với tiền đầu ca như thu ngân.”

**6. Vì sao khách hàng nằm trong sơ đồ tổ chức?**
“Dạ, khách nằm ngoài tổ chức, vẽ nét đứt, để thể hiện quan hệ phục vụ và vì khách là một actor của hệ thống: đặt món qua QR bàn và tích điểm theo số điện thoại. Ở Starbucks đó là thành viên Rewards.”

---

## 2. Context diagram (3 phút)

[Chiếu Figure 1-1; chỉ hình tròn BrewBoss]

“Sơ đồ ngữ cảnh cho thấy BrewBoss trao đổi dữ liệu với những bên nào. Hình tròn ở giữa là toàn bộ hệ thống, bao gồm cả Firebase vì Firebase là backend nằm trong ranh giới hệ thống. Các hình chữ nhật bên ngoài là quản lý, thu ngân, pha chế, khách hàng và dịch vụ VietQR. Mỗi mũi tên đọc theo đầu mũi tên, nhãn là dữ liệu trao đổi; sơ đồ không thể hiện thứ tự công việc.

[Chỉ Owner / Manager]

Quản lý gửi vào hệ thống dữ liệu thiết lập: nhân viên, danh mục, sản phẩm, công thức, nguyên liệu, bàn, voucher, cùng các nghiệp vụ nhập kho, điều chỉnh và kiểm kho. Chiều ngược lại là báo cáo doanh thu, món bán chạy, doanh thu theo phương thức thanh toán, báo cáo bàn giao tiền theo ca, lịch sử kho, danh sách khách và cảnh báo sắp hết nguyên liệu.

[Chỉ Cashier]

Thu ngân là bên có nhiều luồng nhất vì xử lý bán hàng: đăng nhập, tiền đầu ca và tiền kiểm đếm cuối ca, đơn mới và thay đổi món, voucher, số điện thoại khách, điểm đổi, xác nhận tiền mặt hoặc chuyển khoản, chuyển và gộp bàn, huỷ đơn, xác nhận đơn QR. Hệ thống trả về sơ đồ bàn, tổng tiền và tiền thừa, mã VietQR, phiếu thanh toán, thông báo món sẵn sàng, số dư điểm và bảng tổng hợp tiền theo ca.

Trưởng ca dùng đúng các luồng của thu ngân, cộng thêm huỷ đơn đã pha, kiểm kho và xem báo cáo tiền ca. Trên hình, các luồng đó nằm trong ô thu ngân và ô quản lý để sơ đồ không quá dày; bảng phân quyền 3.1.3 mới là nơi tách chi tiết theo bốn vai trò.

[Chỉ Barista]

Pha chế gửi đăng nhập và cập nhật trạng thái đang pha hoặc đã xong; nhận hàng đợi thời gian thực, chi tiết món, cảnh báo đơn mới và đơn quá lâu. Đơn QR chỉ xuất hiện ở đây sau khi thu ngân xác nhận.

[Chỉ Customer]

Khách gửi mã bàn lấy từ QR và yêu cầu đặt món; nhận menu và trạng thái đơn. QR bàn khác QR thanh toán.

[Chỉ VietQR]

Với VietQR, BrewBoss gửi yêu cầu tạo ảnh QR gồm tài khoản ngân hàng, số tiền và mã đơn ngắn; VietQR trả ảnh QR. Không có mũi tên VietQR báo tiền đã vào tài khoản, vì vậy thu ngân phải kiểm tra và xác nhận thủ công; mũi tên xác nhận thanh toán đi từ thu ngân vào hệ thống.

Sơ đồ này chốt phạm vi trao đổi dữ liệu; phần tiếp theo cụ thể hoá thành use case của từng vai trò.”

### Q&A phần 2

**1. Vì sao Firebase không có trên hình, còn Firebase Auth và FCM lại có trên use case?**
“Dạ, ở context diagram Firebase là backend trong ranh giới hệ thống. Trên use case, Auth và FCM được vẽ như dịch vụ hỗ trợ từng chức năng để thấy chức năng nào gọi dịch vụ nào. Hai hình dùng ranh giới khác nhau cho hai mục đích; nhóm ghi rõ điều này dưới Figure 1-1.”

**2. Vì sao không có ô Shift Supervisor trên hình?**
“Dạ, trưởng ca không có loại dữ liệu nào khác ngoài các luồng của thu ngân và một phần của quản lý, nên hình gộp theo nhóm dữ liệu. Nếu thầy muốn, nhóm tách thêm một ô riêng; bảng 3.1.3 đã tách quyền theo bốn vai trò.”

**3. VietQR có tự xác nhận đã nhận tiền không?**
“Dạ không. VietQR chỉ là dịch vụ tạo ảnh QR; không có webhook ngân hàng trong phạm vi này. Thu ngân kiểm tra tài khoản rồi xác nhận.”

**4. Khách có thể đặt đơn từ xa bằng ảnh QR bàn không?**
“Dạ, v1 không kiểm tra vị trí. Đơn từ xa vẫn ở trạng thái awaiting, phải qua xác nhận của thu ngân mới tới pha chế, theo BR-ORD-07.”

**5. Mũi tên là dữ liệu hay thứ tự?**
“Dạ, là luồng dữ liệu. Thứ tự công việc ở sơ đồ quy trình, thứ tự trạng thái ở state machine.”

---

## 3. Use case diagram (5–6 phút)

### 3.1 Cách đọc ký hiệu

[Chiếu Figure 2-3 (D1)]

“SRS có 46 use case, chia thành năm nhóm chức năng D1 đến D5 và sáu góc nhìn theo actor A1 đến A6. Hai cách chia mô tả cùng một hệ thống.

Hình người là actor, gồm người dùng và dịch vụ hỗ trợ. Oval là use case trong khung BrewBoss. Đường liền không mũi tên là association: actor tham gia chức năng đó. Mũi tên tam giác rỗng là generalization: Cashier, Barista, Shift Supervisor và Manager đều là Staff nên dùng chung chức năng của Staff. Mũi tên nét đứt include đi từ chức năng chính tới chức năng được bao gồm; extend đi từ chức năng mở rộng vào chức năng gốc. Chiều mũi tên không phải thứ tự thực hiện.”

### 3.2 D1 — Authentication & Staff (Figure 2-3)

[Chỉ bốn tam giác hướng vào Staff]

“Staff là actor trừu tượng; trong app không có role tên Staff. Staff nối với đăng nhập, đăng xuất, đặt lại mật khẩu và vào ra ca. Đăng nhập và đặt lại mật khẩu nối với Firebase Auth.

[Chỉ Manager và Shift Supervisor]

Manager có UC04 quản lý tài khoản và UC06 xem lịch sử ca. UC45 xem báo cáo tiền ca nối với Shift Supervisor, vì theo quy ước nhóm chỉ vẽ vai trò thấp nhất được dùng chức năng; Manager đương nhiên cũng dùng được.

[Chỉ UC05 include UC44]

Vào ra ca bao gồm bàn giao tiền; bước này áp dụng cho thu ngân, trưởng ca và quản lý khi kết ca, không áp dụng cho pha chế vì ca pha chế không có phần tiền.”

### 3.3 D2 — Menu & Inventory (Figure 2-4)

“Manager quản lý danh mục, sản phẩm, công thức, nguyên liệu, nhập kho, điều chỉnh, lịch sử kho. UC42 kiểm kho nối với Shift Supervisor, trưởng ca làm được và quản lý cũng làm được. Thu ngân bật tắt tình trạng còn món; Staff và khách đều xem được menu.

[Chỉ UC14 → UC08, UC16 → UC13 và UC15, UC43 → UC27]

Công thức mở rộng quản lý sản phẩm. Thanh toán bao gồm trừ kho theo công thức. Cảnh báo kho thấp mở rộng trừ kho và điều chỉnh kho, phát khi tồn chạm ngưỡng tối thiểu, gửi qua FCM. Trừ hao hụt mở rộng huỷ đơn, chỉ khi đồ uống đã được làm.”

### 3.4 D3 — Point of Sale (Figure 2-5)

“Thu ngân xem sơ đồ bàn, tạo đơn, sửa món, xác nhận đơn QR, đánh dấu đã phục vụ, chuyển gộp bàn, huỷ đơn và thu tiền. Tạo đơn bao gồm xem menu. Manager thiết lập bàn, QR và cài đặt quán.

[Chỉ UC27 → UC22 và các extend hướng vào UC25]

Huỷ đơn mở rộng xác nhận đơn QR: thu ngân có thể từ chối đơn khách và ghi lý do. Thanh toán có các phần mở rộng voucher, phiếu thanh toán, thanh toán kết hợp tiền mặt và VietQR; VietQR nối vào UC25 để tạo mã chuyển khoản. Điều kiện thanh toán: đơn đã served và người xác nhận đang có ca mở.”

### 3.5 D4 — Barista Display & Customer Ordering (Figure 2-6)

“Pha chế xử lý hàng đợi, chuyển đơn pending sang preparing rồi ready; UC30 bao gồm UC31 thông báo món sẵn sàng qua FCM. Khách đặt món qua QR bàn, bao gồm xem menu; Firebase Auth tạo phiên ẩn danh nên khách không cần tài khoản; theo dõi trạng thái mở rộng đặt món. Đơn QR tạo ra ở trạng thái awaiting và chỉ tới pha chế sau khi thu ngân xác nhận ở D3.”

### 3.6 D5 — Reports & Loyalty (Figure 2-7)

“Manager xem dashboard, lịch sử đơn, báo cáo bán hàng, xuất báo cáo, quản lý voucher và khách tích điểm. Xuất báo cáo mở rộng xem báo cáo; phiếu thanh toán mở rộng lịch sử đơn. Với thu ngân, gắn khách theo số điện thoại và đổi điểm đều mở rộng thanh toán: khách có thể trả tiền mà không tích điểm.”

### 3.7 Góc nhìn theo actor A1–A6 (nếu còn thời gian)

[Chiếu nhanh Figure 2-8 đến 2-13]

“A1 Staff gom năm chức năng chung. A2 Cashier là luồng bán hàng từ mở ca tới thanh toán. A3 Barista chỉ có hàng đợi và thông báo. A4 Customer là xem menu, đặt qua QR, theo dõi đơn. A5 Manager là các chức năng thiết lập và báo cáo chỉ quản lý mới có.

[Dừng ở Figure 2-13]

A6 Shift Supervisor là hình mới: ba chức năng trưởng ca được dùng ngoài quyền thu ngân và pha chế. UC45 báo cáo tiền ca và UC42 kiểm kho là của trưởng ca; UC27 huỷ đơn được vẽ lại từ A2 vì trưởng ca là cấp thấp nhất được huỷ đơn đã bắt đầu pha, và huỷ đó có thể kéo theo trừ hao hụt UC43.”

### Q&A phần 3

**1. Include khác extend thế nào?**
“Dạ, include là hành vi bắt buộc nằm trong chức năng chính, ví dụ thanh toán luôn trừ kho. Extend là hành vi có điều kiện, ví dụ voucher chỉ áp khi có mã; mũi tên extend đi từ phần mở rộng vào chức năng gốc.”

**2. Staff có phải role thứ năm không?**
“Dạ không. Role lưu trong users.role chỉ có manager, supervisor, cashier, barista. Staff là actor trừu tượng để gom chức năng chung.”

**3. Vì sao UC45 và UC42 nối Shift Supervisor mà không nối Manager?**
“Dạ, quy ước của nhóm là chỉ vẽ vai trò thấp nhất được dùng chức năng để tránh trùng đường. Manager kế thừa mọi quyền, ghi ở mục 2.3.1 và bảng 3.1.3.”

**4. Thu ngân có huỷ được đơn đã pha không?**
“Dạ không. Thu ngân huỷ awaiting và pending. Preparing, ready và served chỉ trưởng ca hoặc quản lý, theo BR-ORD-05. UC43 trừ hao hụt xuất hiện trong hình của thu ngân vì là hành vi tự động liên quan, không phải quyền của thu ngân.”

**5. UC05 include UC44 có đúng với pha chế không?**
“Dạ, include này chỉ chạy ở nhánh kết ca của vai trò có tiền. Pha chế check-out không chạy UC44. Nếu cần chính xác tuyệt đối về UML, nhóm có thể tách use case kết ca có tiền; nhóm giữ hình gọn và ghi rõ điều kiện trong mô tả UC05.”

**6. Vì sao không nối thu ngân thẳng vào voucher, đổi điểm, phiếu thanh toán?**
“Dạ, các chức năng đó chỉ xảy ra trong ngữ cảnh thanh toán nên nối bằng extend vào UC25 để giảm số đường. Mô tả từng use case vẫn ghi thu ngân là actor.”

**7. Vì sao khách đặt QR nối Firebase Auth mà không đăng nhập?**
“Dạ, khách dùng anonymous auth: hệ thống tạo phiên ẩn danh để khách chỉ đọc được đơn của mình, không cần email hay mật khẩu.”

**8. Use case có thể hiện thứ tự tạo đơn, pha, thu tiền không?**
“Dạ không. Use case mô tả ai dùng chức năng gì và quan hệ giữa chức năng. Thứ tự nằm ở phần quy trình ngay sau đây.”

---

## 4. Main workflow (3–4 phút)

### 4.1 Figure 2-1 — một ngày vận hành

[Chiếu Figure 2-1; chỉ các cột]

“Sơ đồ quy trình chia theo cột trách nhiệm: khách hàng, thu ngân, pha chế, quản lý và cột BrewBoss cho việc hệ thống tự làm, các ô nét đứt. Đọc từ trên xuống theo năm giai đoạn: thiết lập, mở ca, phục vụ khách, kết ca, xem báo cáo và bổ sung hàng.

[Chỉ giai đoạn thiết lập]

Thiết lập làm một lần: quản lý nhập menu, công thức, bàn kèm QR, tài khoản nhân viên, rồi nhập kho nguyên liệu với số lượng và chi phí.

[Chỉ mở ca]

Khi quán mở, thu ngân check-in và khai tiền đầu ca; pha chế check-in, không có phần tiền. Mọi thanh toán sau đó thuộc ca của người xác nhận.

[Chỉ Serve customers]

Giai đoạn phục vụ lặp cả ngày. Khách gọi tại quầy hoặc quét QR bàn. Gọi tại quầy thì thu ngân tạo đơn pending. Đặt qua QR thì đơn là awaiting, chưa chiếm bàn và chưa tới pha chế, thu ngân kiểm tra giá và xác nhận.

Hệ thống đẩy đơn sang hàng đợi pha chế theo thời gian thực, mục tiêu dưới hai giây. Pha chế bấm Bắt đầu, rồi bấm Xong; hệ thống báo quầy. Thu ngân giao món và đánh dấu served; ready là pha xong, served là đã giao.

[Chỉ nhánh gọi thêm và nhánh huỷ]

Khách gọi thêm thì món vào đơn đang mở: nếu đơn còn pending hoặc preparing thì vào cùng lượt; nếu đã ready hoặc served thì thành lượt mới và đơn quay về pending, pha chế chỉ thấy lượt mới. Nếu khách huỷ sau khi đã bắt đầu pha, chỉ trưởng ca hoặc quản lý được huỷ, phải ghi lý do; đồ đã làm thì trừ nguyên liệu dưới dạng hao hụt.

[Chỉ Take payment và ô trừ kho tự động]

Khách yêu cầu tính tiền: thu ngân nhận tiền mặt, VietQR hoặc kết hợp, có thể áp voucher và đổi điểm. Chỉ đơn served mới thanh toán. Sau thanh toán, trong một transaction, hệ thống đóng đơn, trừ kho theo công thức, cộng điểm, tăng lượt dùng voucher và trả bàn về trống; dashboard ghi doanh thu.

[Chỉ kết ca]

Cuối ca, thu ngân kiểm đếm và bàn giao: tiền dự kiến bằng tiền đầu ca cộng tiền mặt của các đơn người đó xác nhận trong ca, không cộng VietQR. Chênh lệch khác không phải ghi chú; sau check-out các trường tiền bị khoá. Pha chế chỉ check-out.

[Chỉ Review and replenish]

Cuối cùng, quản lý xem dashboard, báo cáo và bàn giao tiền; trưởng ca hoặc quản lý xem báo cáo tiền từng ca và kiểm kho trước khi đặt thêm hàng. Cảnh báo kho thấp có thể phát bất kỳ lúc nào trong ngày khi tồn chạm ngưỡng.”

### 4.2 Figure 2-2 — state machine (30 giây)

[Chiếu Figure 2-2]

“Trạng thái đơn khớp với quy trình vừa nói: awaiting sang pending khi thu ngân xác nhận, hoặc cancelled khi từ chối; pending, preparing, ready, served, paid là đường chính; ready hoặc served quay về pending khi thêm món; pending tới served có thể sang cancelled; paid và cancelled là trạng thái kết thúc.”

### Q&A phần 4

**1. Vì sao chỉ thanh toán sau served, quán thật thường thu trước?**
“Dạ, nhóm chọn một luồng trạng thái thống nhất theo BR-PAY-04 cho phiên bản này; thu trước là thay đổi yêu cầu và state machine, nhóm ghi nhận là việc có thể mở rộng.”

**2. Vì sao trừ kho lúc thanh toán mà không trừ lúc tạo đơn?**
“Dạ, đơn mở còn sửa hoặc huỷ; chốt kho khi paid tránh trừ nhiều lần. Đồ huỷ đã làm được trừ riêng dưới dạng hao hụt.”

**3. Gọi thêm qua QR khi bàn đã có đơn thì có hai hoá đơn không?**
“Dạ không. Sau xác nhận, món QR vào đơn mở của bàn; đơn QR nguồn đóng với lý do gộp và liên kết tới đơn đích.”

**4. Đơn thanh toán kết hợp được đối soát thế nào?**
“Dạ, cashAmount cộng qrAmount bằng total. Tiền dự kiến cuối ca chỉ cộng cashAmount; qrAmount tổng hợp riêng.”

**5. Nhiều thu ngân thì đơn thuộc ca ai?**
“Dạ, thuộc ca của người xác nhận paid, dựa trên paidBy và paidAt.”

**6. Không khớp tiền thì hệ thống xử lý gì?**
“Dạ, hệ thống tính chênh lệch, bắt buộc ghi chú và lưu cho trưởng ca hoặc quản lý xem; không tự bù và không tính lương.”

**7. Huỷ khi preparing có luôn trừ hao hụt không?**
“Dạ không. Người huỷ đánh dấu đồ đã làm hay chưa; mặc định chưa chọn ở preparing, chọn ở ready và served.”

**8. Sơ đồ này có phải BPMN đầy đủ không?**
“Dạ, đây là flowchart theo swimlane để mô tả nghiệp vụ, không dùng đủ ký hiệu BPMN. Quy tắc chi tiết nằm trong mục 5.1 Business Rules.”

---

## 5. Kết thúc (20 giây)

“Tóm lại: cơ cấu tổ chức lấy mô hình cửa hàng Starbucks có ghi nguồn, từ đó ra bốn vai trò nhân viên; sơ đồ ngữ cảnh chốt dữ liệu trao đổi với từng vai trò và VietQR; use case cụ thể hoá 46 chức năng theo vai trò; và quy trình một ngày cho thấy thứ tự phối hợp giữa các chức năng. Em xin dừng phần sơ đồ ở đây, sẵn sàng nhận câu hỏi.”

---

## Phụ lục A — Khi bị hỏi, chỉ vào đâu

| Câu hỏi thường gặp | Chỗ trong SRS |
|---|---|
| Nguồn của cơ cấu Starbucks | Mục 1, đoạn “Starbucks does not publish an organization chart”; bảng bằng chứng dưới Figure 1-2; mục 5.5 nguồn [1]–[4]; ảnh chụp ở 5.6 |
| Vai trò Starbucks ứng với vai trò nào trong app | Bảng ánh xạ ngay sau Figure 1-3 |
| Trưởng ca được làm gì | Mục 2.2 actor #4; cột Supervisor trong 3.1.3; Figure 2-13 |
| Ai được huỷ đơn khi nào | BR-ORD-05 trong 5.1; UC27 |
| Tiền cuối ca tính thế nào | BR-STAFF-03 đến 05; UC44, UC45 |
| Firebase ở trong hay ngoài hệ thống | Đoạn dưới Figure 1-1 (trong); ghi chú actor ngoài ở 2.3.1 (dịch vụ hỗ trợ) |
| Thứ tự trạng thái đơn | Figure 2-2 và bảng chuyển trạng thái trong 2.1.2 |

## Phụ lục B — Checklist trước khi trình bày

- Mở SRS bằng Word, cập nhật field để mục lục có 5.5 và 5.6.
- Đánh dấu trang: Figure 1-2, bảng bằng chứng, Figure 1-3, bảng ánh xạ, Figure 1-1, Figure 2-3, 2-5, 2-6, 2-13, Figure 2-1, 2-2.
- Mở sẵn thư mục `source-evidence` phòng khi được yêu cầu xem trang gốc; nếu có mạng, mở `careers.starbucks.com/discover-opportunities/coffeehouses/` và bấm tab District Manager để chứng minh câu trích.
- Thuộc ba con số: 46 use case, 4 vai trò nhân viên cộng khách, 10 nguồn trong 5.5.
- Luyện bản 8 phút trước; chỉ nói đủ 15 phút nếu thầy cho thời gian.
