<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    // 로그인 상태 확인
    String username = null;

    if (session != null) {
        username = (String) session.getAttribute("username");
    }

    if (username == null) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("username")) {
                    username = cookie.getValue();
                    break;
                }
            }
        }
    }

    // 로그인되지 않은 경우 로그인 페이지로 리다이렉트
    if (username == null) {
    	out.println("<script>alert('로그인이 필요합니다. 로그인 후 다시 시도해주세요.'); location.href='login.jsp';</script>");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>알바모아</title>
    <style>
		h1 {
		    text-align: center;
		    margin-bottom: 30px;
		}
		
		#notice {
		    max-width: 800px;
		    margin: 0 auto;
		    background-color: #fff;
		    padding: 20px;
		    border-radius: 8px;
		    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
		}
		
		.form-group {
		    margin-bottom: 15px;
		}
		
		.form-control {
		    width: 100%;
		    padding: 10px;
		    box-sizing: border-box;
		    border: 1px solid #ccc;
		    border-radius: 4px;
		}
		
		.form-control-inline {
		    display: flex;
		    justify-content: flex-start;
		    padding: 10px;
		    border: 1px solid #ccc;
		    border-radius: 4px;
		}
		
		.form-control[type="checkbox"], .form-control[type="radio"] {
		    width: auto;
		}
		
		.form-group-inline {
		    display: flex;
		    justify-content: flex-start;
		    align-items: center;
		}
		
		.form-group-inline .form-group {
		    flex: 1;
		    margin-right: 10px;
		}
		
		.form-group-inline .form-group:last-child {
		    margin-right: 0;
		}
		
		.form-group-inline .form-control-inline {
		    width: auto;
		    margin-right: 10px;
		}
		
		.form-group-inline label {
		    margin-right: 10px;
		    display: flex;
		    align-items: center;
		}
		
		.form-buttons {
		    text-align: center;
		    margin-top: 20px;
		}
		
		button {
		    background-color: #FD9F28;
		    color: #fff;
		    padding: 10px 20px;
		    border: none;
		    border-radius: 4px;
		    cursor: pointer;
		    font-size: 16px;
		}
		
		button:hover {
		    background-color: #FD991C;
		}
		
		@media (max-width: 768px) {
		    .form-group-inline {
		        flex-direction: column;
		    }
		    
		    .form-group-inline .form-group {
		        margin-right: 0;
		        margin-bottom: 15px;
		    }
		    
		    .form-group-inline .form-group:last-child {
		        margin-bottom: 0;
		    }
		    
		    .form-control-inline {
		        margin-right: 0;
		        margin-bottom: 10px;
		    }
		    
		    .form-control-inline:last-child {
		        margin-bottom: 0;
		    }
		}
		
		.checkbox-group, .radio-group {
		    display: flex;
		    flex-wrap: wrap;
		    gap: 10px;
		    align-items: center;
		}
		
		.checkbox-group label, .radio-group label {
		    display: flex;
		    align-items: center;
		    margin-right: 15px;
		}
		
		.checkbox-group input, .radio-group input {
		    margin-right: 5px;
		}
		
		.popup {
		    display: none;
		    position: fixed;
		    top: 50%;
		    left: 50%;
		    transform: translate(-50%, -50%);
		    background-color: #fff;
		    border: 1px solid #ccc;
		    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
		    z-index: 1000;
		    padding: 20px;
		    width: 60%;
		    text-align: center;
		    border-radius: 8px;
		}
		
		.popup-header {
		    font-weight: bold;
		    margin-bottom: 20px;
		}
		
		.popup-close {
		    background-color: #ff5c5c;
		    color: white;
		    border: none;
		    padding: 5px 10px;
		    cursor: pointer;
		    border-radius: 4px;
		    margin-top: 20px;
		}
		
		.overlay {
		    display: none;
		    position: fixed;
		    top: 0;
		    left: 0;
		    width: 100%;
		    height: 100%;
		    background-color: rgba(0, 0, 0, 0.5);
		    z-index: 999;
		}
		
		.close-btn {
			display: flex;
			justify-content: flex-end;
			margin-left: 10px;
            color: red;
            cursor: pointer;
		}
		
		.selected-business-type {
		    display: inline-block;
		    background-color: #f1f1f1;
		    border-radius: 4px;
		    padding: 5px 10px;
		    margin: 5px;
		}
		
		.remove-type {
		    margin-left: 10px;
		    color: red;
		    cursor: pointer;
		}
		
		.small-button {
		    padding: 5px 10px;
		    font-size: 14px;
		    width: 15%;
		    margin-bottom: 5px;
		}
		
		#address, #detailAddress, #extraAddress {
		    height: 40px; /* 주요사업내용 높이와 일치시킴 */
		    padding: 10px;
		    box-sizing: border-box;
		    border: 1px solid #ccc;
		    border-radius: 4px;
		    margin-bottom: 10px;
		    width: 37%;
		}
		
		#person, #salary, #start-time, #end-time, #scholarship, #end-date {
		    width: 150px;
		    display: inline-block;
		    padding: 10px;
		    box-sizing: border-box;
		    border: 1px solid #ccc;
		    border-radius: 4px;
		    margin-right: 10px;
		}	
    </style>
</head>
<body>
	<jsp:include page="navbar.jsp" />
    <h1>공고 등록</h1>
    <form id="notice" name="notice" action="notice_send.jsp" method="post">
        <h3>기업정보</h3>
        주요사업내용
        <div class="form-group">
            <input type="text" id="business" name="business" class="form-control">
        </div>
        주소
        <div class="form-group">
		    <input type="button" onclick="addressFind()" class="form-control small-button" value="주소 찾기">
		    <div class="form-group-inline">
		        <input type="text" id="address" name="address" class="form-control-inline" placeholder="주소">
		        <input type="text" id="detailAddress" name="detailAddress" class="form-control-inline" placeholder="상세주소">
		        <input type="text" id="extraAddress" name="extraAddress" class="form-control-inline" placeholder="참고항목">
		    </div>
		</div>
        <hr>
        <h3>모집내용</h3>
        공고제목
        <div class="form-group">
            <input type="text" id="title" name="title" class="form-control">
        </div>
        근무회사명
        <div class="form-group">
            <input type="text" id="company" name="company" class="form-control">
        </div>
        고용형태
        <div class="form-group">
            <div class="radio-group">
                <label><input type="radio" name="employment_type" value=1>일반</label>
                <label><input type="radio" name="employment_type" value=2>정규직</label>
                <label><input type="radio" name="employment_type" value=3>계약직</label>
                <label><input type="radio" name="employment_type" value=4>파견직</label>
                <label><input type="radio" name="employment_type" value=5>인턴</label>
            </div>
        </div>
        업직종
		<div class="form-group">
		    <input type="button" id="business_type_button" class="form-control small-button" value="업직종 선택">
		    <div id="selected-business-types" class="form-control" style="margin-top: 10px; display: flex; flex-wrap: wrap;"></div>
		    <input type="hidden" id="business_types" name="business_types">
		</div>
        모집인원
        <div class="form-group">
		    <div class="form-group-inline">
		        <input type="text" id="person" name="person" class="form-control-inline"> 명
		    </div>
		</div>
        <hr>
        <h3>근무조건</h3>
        근무기간
        <div class="form-group">
            <div class="radio-group">
                <label><input type="radio" name="period" value="1">하루(1일)</label>
                <label><input type="radio" name="period" value="2">1주일이하</label>
                <label><input type="radio" name="period" value="3">1주일~1개월</label>
                <label><input type="radio" name="period" value="4">1개월~3개월</label>
                <label><input type="radio" name="period" value="5">3개월~6개월</label>
                <label><input type="radio" name="period" value="6">6개월~1년</label>
                <label><input type="radio" name="period" value="7">1년이상</label>
                <label><input type="checkbox" name="period_flexible">협의가능</label>
            </div>
        </div>
        근무요일
        <div class="form-group">
            <div class="radio-group">
                <label><input type="radio" name="week" value="1">월~일</label>
                <label><input type="radio" name="week" value="2">월~토</label>
                <label><input type="radio" name="week" value="3">월~금</label>
                <label><input type="radio" name="week" value="4">주말(토,일)</label>
                <label><input type="radio" name="week" value="5">요일협의</label>
            </div>
        </div>
        근무시간
        <div class="form-group">
		    <div class="form-group-inline">
		        <select id="start-time" name="start_time" class="form-control-inline">
		            <option value="start">시작시간</option>
		            <option value="00:00">00:00</option>
		            <option value="00:30">00:30</option>
		            <option value="01:00">01:00</option>
		            <option value="01:30">01:30</option>
		            <option value="02:00">02:00</option>
		            <option value="02:30">02:30</option>
		            <option value="03:00">03:00</option>
		            <option value="03:30">03:30</option>
		            <option value="04:00">04:00</option>
		            <option value="04:30">04:30</option>
		            <option value="05:00">05:00</option>
		            <option value="05:30">05:30</option>
		            <option value="06:00">06:00</option>
		            <option value="06:30">06:30</option>
		            <option value="07:00">07:00</option>
		            <option value="07:30">07:30</option>
		            <option value="08:00">08:00</option>
		            <option value="08:30">08:30</option>
		            <option value="09:00">09:00</option>
		            <option value="09:30">09:30</option>
		            <option value="10:00">10:00</option>
		            <option value="10:30">10:30</option>
		            <option value="11:00">11:00</option>
		            <option value="11:30">11:30</option>
		            <option value="12:00">12:00</option>
		            <option value="12:30">12:30</option>
		            <option value="13:00">13:00</option>
		            <option value="13:30">13:30</option>
		            <option value="14:00">14:00</option>
		            <option value="14:30">14:30</option>
		            <option value="15:00">15:00</option>
		            <option value="15:30">15:30</option>
		            <option value="16:00">16:00</option>
		            <option value="16:30">16:30</option>
		            <option value="17:00">17:00</option>
		            <option value="17:30">17:30</option>
		            <option value="18:00">18:00</option>
		            <option value="18:30">18:30</option>
		            <option value="19:00">19:00</option>
		            <option value="19:30">19:30</option>
		            <option value="20:00">20:00</option>
		            <option value="20:30">20:30</option>
		            <option value="21:00">21:00</option>
		            <option value="21:30">21:30</option>
		            <option value="22:00">22:00</option>
		            <option value="22:30">22:30</option>
		            <option value="23:00">23:00</option>
		            <option value="23:30">23:30</option>
		        </select>
		        ~  
		        <select id="end-time" name="end_time" class="form-control-inline">
		            <option value="end">종료시간</option>
		            <option value="00:00">00:00</option>
		            <option value="00:30">00:30</option>
		            <option value="01:00">01:00</option>
		            <option value="01:30">01:30</option>
		            <option value="02:00">02:00</option>
		            <option value="02:30">02:30</option>
		            <option value="03:00">03:00</option>
		            <option value="03:30">03:30</option>
		            <option value="04:00">04:00</option>
		            <option value="04:30">04:30</option>
		            <option value="05:00">05:00</option>
		            <option value="05:30">05:30</option>
		            <option value="06:00">06:00</option>
		            <option value="06:30">06:30</option>
		            <option value="07:00">07:00</option>
		            <option value="07:30">07:30</option>
		            <option value="08:00">08:00</option>
		            <option value="08:30">08:30</option>
		            <option value="09:00">09:00</option>
		            <option value="09:30">09:30</option>
		            <option value="10:00">10:00</option>
		            <option value="10:30">10:30</option>
		            <option value="11:00">11:00</option>
		            <option value="11:30">11:30</option>
		            <option value="12:00">12:00</option>
		            <option value="12:30">12:30</option>
		            <option value="13:00">13:00</option>
		            <option value="13:30">13:30</option>
		            <option value="14:00">14:00</option>
		            <option value="14:30">14:30</option>
		            <option value="15:00">15:00</option>
		            <option value="15:30">15:30</option>
		            <option value="16:00">16:00</option>
		            <option value="16:30">16:30</option>
		            <option value="17:00">17:00</option>
		            <option value="17:30">17:30</option>
		            <option value="18:00">18:00</option>
		            <option value="18:30">18:30</option>
		            <option value="19:00">19:00</option>
		            <option value="19:30">19:30</option>
		            <option value="20:00">20:00</option>
		            <option value="20:30">20:30</option>
		            <option value="21:00">21:00</option>
		            <option value="21:30">21:30</option>
		            <option value="22:00">22:00</option>
		            <option value="22:30">22:30</option>
		            <option value="23:00">23:00</option>
		            <option value="23:30">23:30</option>
		        </select>
		        <label><input type="checkbox" id="time-flexible" name="time_flexible">시간협의</label>
		    </div>
		</div>
		급여
        <div class="form-group">
		    <div class="form-group-inline">
		        <select id="salary_type" name="salary_type" class="form-control-inline">
		            <option value="1">시급</option>
		            <option value="2">일급</option>
		            <option value="3">주급</option>
		            <option value="4">월급</option>
		            <option value="5">연봉</option>
		        </select>
		        <input type="text" id="salary" name="salary" class="form-control-inline"> 원
		        <label><input type="checkbox" id="salary-flexible" name="salary_flexible">급여협의</label>
		    </div>
		</div>
        <hr>
        <h3>지원조건</h3>
        성별
        <div class="form-group">
            <div class="radio-group">
                <label><input type="radio" name="sex" value="성별무관">성별무관</label>
                <label><input type="radio" name="sex" value="남자">남자</label>
                <label><input type="radio" name="sex" value="여자">여자</label>
            </div>
        </div>
        연령
        <div class="form-group">
            <div class="radio-group">
                <label><input type="radio" name="age" value="연령무관">연령무관</label>
                <label><input type="radio" name="age" value="limit">연령제한 있음</label>
                <input type="text" id="age_min" name="age_min" class="form-control-inline" disabled>세 ~ <input type="text" id="age_max" name="age_max" class="form-control-inline" disabled>세 이하
            </div>
        </div>
        학력조건
        <div class="form-group">
            <select id="scholarship" name="scholarship" class="form-control">
                <option value="every">학력무관</option>
                <option value="middle">중학교 졸업</option>
                <option value="high">고등학교 졸업</option>
                <option value="two-university">2년제 대학 졸업</option>
                <option value="university">4년제 대학 졸업</option>
                <option value="graduate">대학원 졸업</option>
            </select>
        </div>
        우대조건
        <div class="form-group">
            <div class="checkbox-group">
                <label><input type="checkbox" name="sweeteners" value="영어 가능">영어 가능</label>
                <label><input type="checkbox" name="sweeteners" value="일본어 가능">일본어 가능</label>
                <label><input type="checkbox" name="sweeteners" value="중국어 가능">중국어 가능</label>
                <label><input type="checkbox" name="sweeteners" value="컴퓨터 활용 가능">컴퓨터 활용 가능</label>
                <label><input type="checkbox" name="sweeteners" value="포토샵 가능">포토샵 가능</label>
                <label><input type="checkbox" name="sweeteners" value="한글(HWP) 가능">한글(HWP) 가능</label>
                <label><input type="checkbox" name="sweeteners" value="워드 가능">워드 가능</label>
                <label><input type="checkbox" name="sweeteners" value="파워포인트 가능">파워포인트 가능</label>
                <label><input type="checkbox" name="sweeteners" value="엑셀 가능">엑셀 가능</label>
                <label><input type="checkbox" name="sweeteners" value="차량소지">차량소지</label>
                <label><input type="checkbox" name="sweeteners" value="운전 가능">운전 가능</label>
                <label><input type="checkbox" name="sweeteners" value="업무 관련 자격증 소지">업무 관련 자격증 소지</label>
                <label><input type="checkbox" name="sweeteners" value="유사업무 경험">유사업무 경험</label>
                <label><input type="checkbox" name="sweeteners" value="인근 거주">인근 거주</label>
                <label><input type="checkbox" name="sweeteners" value="대학 재학생">대학 재학생</label>
                <label><input type="checkbox" name="sweeteners" value="대학 휴학생">대학 휴학생</label>
            </div>
        </div>
        <hr>
        <h3>접수기간∙방법</h3>
        모집종료일
        <div class="form-group">
		    <div class="form-group-inline">
		        <input type="date" id="end-date" name="end-date" class="form-control-inline">
		        <label><input type="checkbox" id="end-date-flexible" name="end_date_flexible">상시모집</label>
		    </div>
		</div>
		접수방법
        <div class="form-group">
            <div class="checkbox-group">
                <label><input type="radio" name="reception_method" value="online">온라인지원</label>
                <label><input type="radio" name="reception_method" value="message">간편문자지원</label>
                <label><input type="radio" name="reception_method" value="email">이메일지원</label>
                <label><input type="radio" name="reception_method" value="phone">전화연락</label>
                <label><input type="radio" name="reception_method" value="visit">바로방문</label>
            </div>
        </div>
        <hr>
        <h3>담당자 정보</h3>
        담당자명
        <div class="form-group">
            <input type="text" id="name" name="name" class="form-control">
        </div>
        이메일
        <div class="form-group">
            <input type="email" id="contact_email" name="contact_email" class="form-control">
        </div>
        전화번호
        <div class="form-group">
            <input type="text" id="phone" name="phone" class="form-control" placeholder="01012341234">
        </div>
        <div class="form-buttons">
            <button type="submit">공고 등록</button>
        </div>
    </form>

    <div class="overlay" id="overlay"></div>
    <div class="popup" id="popup">
        <div class="close-btn">x</div>
        <div class="popup-header">업직종 선택</div>
        <div class="checkbox-group" id="business-types"></div>
        <button class="popup-next" id="popup-next">다음</button>
    </div>
    
    <div class="popup" id="popup-detail">
        <div class="close-btn">x</div>
        <div class="popup-header">상세 업직종 선택</div>
        <div class="checkbox-group" id="business-detail-types"></div>
        <button class="popup-close-detail" id="popup-close-detail">완료</button>
    </div>
    
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('business_type_button').addEventListener('click', function() {
            fetch('getBusinessTypes.jsp')
                .then(response => response.json())
                .then(data => {
                    const businessTypesContainer = document.getElementById('business-types');
                    businessTypesContainer.innerHTML = '';
                    data.forEach(item => {
                        const label = document.createElement('label');
                        const checkbox = document.createElement('input');
                        checkbox.type = 'checkbox';
                        checkbox.value = item.value;
                        label.appendChild(checkbox);
                        label.appendChild(document.createTextNode(item.text));
                        businessTypesContainer.appendChild(label);
                    });
                    document.getElementById('overlay').style.display = 'block';
                    document.getElementById('popup').style.display = 'block';
                })
                .catch(error => console.error('Error:', error));
        });

        document.getElementById('popup-next').addEventListener('click', function() {
            const selectedTypes = Array.from(document.querySelectorAll('#business-types input[type="checkbox"]:checked')).map(checkbox => ({
                value: checkbox.value,
                text: checkbox.nextSibling.textContent
            }));
            if (selectedTypes.length > 0) {
                fetch('getBusinessDetailTypes.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ selectedTypes: selectedTypes.map(type => type.value) })
                })
                    .then(response => response.json())
                    .then(data => {
                        const businessDetailTypesContainer = document.getElementById('business-detail-types');
                        businessDetailTypesContainer.innerHTML = '';
                        data.forEach(item => {
                            const label = document.createElement('label');
                            const checkbox = document.createElement('input');
                            checkbox.type = 'checkbox';
                            checkbox.value = item.value;
                            label.appendChild(checkbox);
                            label.appendChild(document.createTextNode(item.text));
                            businessDetailTypesContainer.appendChild(label);
                        });
                        document.getElementById('popup').style.display = 'none';
                        document.getElementById('popup-detail').style.display = 'block';
                    })
                    .catch(error => console.error('Error:', error));
            } else {
                alert('업직종을 하나 이상 선택해주세요.');
            }
        });

        document.getElementById('popup-close-detail').addEventListener('click', function() {
            const selectedDetailTypes = Array.from(document.querySelectorAll('#business-detail-types input[type="checkbox"]:checked'))
                .map(checkbox => ({
                    value: checkbox.value,
                    text: checkbox.nextSibling.textContent
                }));

            const selectedBusinessTypesContainer = document.getElementById('selected-business-types');
            const businessTypesInput = document.getElementById('business_types');

            selectedDetailTypes.forEach(type => {
                const typeElement = document.createElement('span');
                typeElement.classList.add('selected-business-type');
                typeElement.textContent = type.text;

                const removeButton = document.createElement('span');
                removeButton.classList.add('remove-type');
                removeButton.textContent = 'x';
                removeButton.addEventListener('click', function() {
                    selectedBusinessTypesContainer.removeChild(typeElement);
                    updateBusinessTypesInput();
                });

                typeElement.appendChild(removeButton);
                selectedBusinessTypesContainer.appendChild(typeElement);
            });

            updateBusinessTypesInput();

            document.getElementById('overlay').style.display = 'none';
            document.getElementById('popup-detail').style.display = 'none';
        });

        document.querySelectorAll('.close-btn').forEach(function(button) {
            button.addEventListener('click', function() {
                document.getElementById('overlay').style.display = 'none';
                this.parentElement.style.display = 'none';
            });
        });

        function updateBusinessTypesInput() {
            const selectedTypes = Array.from(document.querySelectorAll('.selected-business-type'))
                .map(element => element.textContent.replace('x', '').trim());
            document.getElementById('business_types').value = selectedTypes.join(',');
        }
    });

    document.querySelectorAll('input[name="age"]').forEach(function(radio) {
        radio.addEventListener('change', function() {
            const isAgeLimit = document.querySelector('input[name="age"][value="limit"]').checked;
            document.getElementById('age_min').disabled = !isAgeLimit;
            document.getElementById('age_max').disabled = !isAgeLimit;
        });
    });
    
    document.getElementById('time-flexible').addEventListener('change', function() {
        const isTimeFlexible = this.checked;
        document.getElementById('start-time').disabled = isTimeFlexible;
        document.getElementById('end-time').disabled = isTimeFlexible;
    });

    document.getElementById('end-date-flexible').addEventListener('change', function() {
        const isEndDateFlexible = this.checked;
        document.getElementById('end-date').disabled = isEndDateFlexible;
    });
	
    function addressFind() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if(data.userSelectedType === 'R'){
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    // 조합된 참고항목을 해당 필드에 넣는다.
                    document.getElementById("extraAddress").value = extraAddr;
                
                } else {
                    document.getElementById("extraAddress").value = '';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById("address").value = addr;
                // 커서를 상세주소 필드로 이동한다.
                document.getElementById("detailAddress").focus();
            }
        }).open();
    }
    </script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</body>
</html>
